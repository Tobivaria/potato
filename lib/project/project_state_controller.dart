import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/language/language.dart';
import 'package:potato/language/mutable_language_data.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/notification/notification_controller.dart';
import 'package:potato/project/project_file.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/utils/potato_logger.dart';

/// Absolut path of the potato project file
final StateProvider<String> absolutProjectPath = StateProvider<String>(
  (ref) => '',
);

/// Absolut path of the translation files
final StateProvider<String> absolutTranslationPath = StateProvider<String>(
  (ref) => '',
);

/// Contains then input from filter, entered in the translation view
final StateProvider<String> idFilter = StateProvider<String>(
  (ref) => '',
);

/// Filters the ids and sorts them a to z
final Provider<List<String>> filteredOrderedIds = Provider<List<String>>((ref) {
  final String filter = ref.watch(idFilter).toLowerCase();
  final Map<String, MetaDefinition> metaDefs = ref.watch(
    projectStateProvider.select(
      (value) => value.languageData.metaDefinitions,
    ),
  );

  final List<String> sorted = metaDefs.keys.toList()..sort();

  if (filter.isEmpty) {
    return sorted;
  }

  return sorted
      .where((element) => element.toLowerCase().contains(filter))
      .toList();
});

/// Provides if the project state can be undone
final StateProvider<bool> canUndo = StateProvider<bool>((ref) {
  // watch vor state changes
  // TODO find another way to achieve this
  final unused = ref.watch(projectStateProvider);
  return ref.read(projectStateProvider.notifier).canUndo;
});

/// Provides if the project state can be redone
final StateProvider<bool> canRedo = StateProvider<bool>((ref) {
  // watch vor state changes
  // TODO find another way to achieve this
  final unused = ref.watch(projectStateProvider);
  return ref.read(projectStateProvider.notifier).canRedo;
});

final StateNotifierProvider<ProjectStateController, ProjectState>
    projectStateProvider =
    StateNotifierProvider<ProjectStateController, ProjectState>(
        (StateNotifierProviderRef<ProjectStateController, ProjectState> ref) {
  return ProjectStateController(
    ref.watch(fileServiceProvider),
    ref.watch(loggerProvider),
    ref,
  );
});

class ProjectStateController extends StateNotifier<ProjectState> {
  final FileService fileService;
  final Logger logger;
  Ref ref;

  List<ProjectState> _history = [];
  int _historyIndex = -1;

  ProjectStateController(
    this.fileService,
    this.logger,
    this.ref, [
    ProjectState? init,
  ]) : super(init ?? ProjectState());

  void loadfromJsons(List<Map<String, dynamic>> data) {
    final Map<String, MetaDefinition> metaDefinitions = {};
    final Map<String, Language> languages = {};

    // TODO error handling
    String? baseLang;

    // iterate over jsons
    for (final Map<String, dynamic> entry in data) {
      String locale = '';
      final Map<String, String> translations = {};

      // extract data from json
      for (final String key in entry.keys) {
        final dynamic item = entry[key] as dynamic;
        if (key == '@@locale') {
          locale = item as String;
        } else if (key.startsWith('@')) {
          metaDefinitions[key.substring(1)] =
              MetaDefinition.fromMap(Map<String, dynamic>.from(item as Map));
          baseLang ??= locale;
        } else {
          translations[key] = item as String;
        }
      }

      languages[locale] = Language(existingTranslations: translations);
    }

    if (baseLang == null) {
      ref.read(notificationController.notifier).add(
            'Base language missing',
            'Please define one.',
            InfoBarSeverity.error,
          );
    }

    setBaseLanguage(baseLang);

    // remove the previous created states from history
    _clearHistory();

    _updateState(
      updateLanguages: languages,
      updateMetaDefs: metaDefinitions,
    );
  }

  void addLanguage(String langKey) {
    logger.d('Adding language: $langKey');

    if (state.languageData.languages.isEmpty) {
      // mark first language as base language
      setBaseLanguage(langKey);
      // add an empty translation
      addTranslation();
    }

    state =
        state.copyWith(languageData: state.languageData.addLanguage(langKey));
  }

  /// Remove an existing language from the project
  void removeLanguage(String langToRemove) {
    logger.d('Removing language: $langToRemove');

    state = state.copyWith(
      languageData: state.languageData.removeLanguage(langToRemove),
    );

    if (langToRemove == state.file.baseLanguage) {
      // invalidate base language
      setBaseLanguage(null);
    }
  }

  // TODO remove file service dependency
  Future<void> export(String pathToExportTo) async {
    final List<String> keys = state.languageData.metaDefinitions.keys.toList();
    // sort keys alphabetically
    keys.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    for (final language in state.languageData.languages.keys) {
      final data = state.languageData.exportLanguage(
        language,
        keys,
        isMainLanguage: language == state.file.baseLanguage,
        mainLanguage: state.languageData.languages[state.file.baseLanguage],
      );
      final File file = File('$pathToExportTo/app_$language.arb');
      await fileService.writeFile(file, data);
    }
  }

  void addTranslation() {
    state = state.copyWith(
      languageData: state.languageData.addKey(),
    );
  }

  /// Removes the key itself and from all languages
  void removeTranslation(String keyToRemove) {
    logger.d('Removing translation with key: $keyToRemove');

    state = state.copyWith(
      languageData: state.languageData.removeKey(keyToRemove),
    );
  }

  /// Updates the key in the meta definition and all languages
  void updateKey(String oldKey, String newKey) {
    logger.d('Updating key from "$oldKey" to "$newKey"');

    if (state.languageData.metaDefinitions.containsKey(newKey)) {
      logger.w('Key already exists and cannot be renamed');
      ref.read(notificationController.notifier).add(
            'Duplicate key',
            '$newKey as key already exists',
            InfoBarSeverity.error,
          );
      return;
    }

    state = state.copyWith(
      languageData: state.languageData.updateKey(oldKey, newKey),
    );
  }

  void addDescription(String key) {
    logger.d('Add description for key "$key"');

    state =
        state.copyWith(languageData: state.languageData.addDescription(key));
  }

  void removeDescription(String key) {
    logger.d('Removing description of key "$key"');

    state =
        state.copyWith(languageData: state.languageData.removeDescription(key));
  }

  void updateDescription(String key, String description) {
    logger.d('Updating description of key "$key" to "$description"');

    state = state.copyWith(
      languageData: state.languageData.updateDescription(key, description),
    );
  }

  void updateTranslation(String langKey, String key, String translation) {
    logger.d(
      'Updating translation for "$langKey" entry "$key" to "$translation"',
    );

    state = state.copyWith(
      languageData:
          state.languageData.updateTranslation(langKey, key, translation),
    );
  }

  void addPlaceholder(String key) {
    logger.d(
      'Adding placeholder for entry "$key"',
    );

    state =
        state.copyWith(languageData: state.languageData.addPlaceholder(key));
  }

  void updatePlaceholder({
    required String key,
    required String placeholderId,
    String? updatedId,
    String? updatedExample,
    MetaType? updatedType,
  }) {
    logger.d(
      'Updating placeholder id "$placeholderId" for entry "$key" to ${updatedId == null ? "" : "id: $updatedId"} ${updatedExample == null ? "" : "example: $updatedExample"} ${updatedType == null ? "" : "type: $updatedType"} ',
    );

    // TODO move this into the UI/ Widget, then get rid of the notifier dependency
    if (updatedId != null) {
      // validate the new id is not already in use
      if (!state.languageData.isPlaceholderIdUnique(key, updatedId)) {
        logger.w('Placeholder already exists and cannot be renamed');
        ref.read(notificationController.notifier).add(
              'Duplicated placeholder',
              '$updatedId placeholder already exists',
              InfoBarSeverity.error,
            );
        return;
      }
    }

    state = state.copyWith(
      languageData: state.languageData.updatePlaceholder(
        key: key,
        id: placeholderId,
        updatedId: updatedId,
        updatedExample: updatedExample,
        updatedType: updatedType,
      ),
    );
  }

  void removePlaceholder(String key, String placeholderId) {
    logger.d(
      'Removing placeholder for entry "$key" with id "$placeholderId"',
    );

    state = state.copyWith(
      languageData: state.languageData.removePlaceHolder(key, placeholderId),
    );
  }

  /// Returns language codes which translations are empty
  List<String> getEmptyTranslations(String key) {
    final out = <String>[];
    final langs = state.languageData.languages;

    for (final lang in langs.keys) {
      if (lang != state.file.baseLanguage) {
        final String translation = langs[lang]!.translations[key]!;
        if (translation.isEmpty) {
          out.add(lang);
        }
      }
    }
    return out;
  }

  void _updateState({
    Map<String, Language>? updateLanguages,
    Map<String, MetaDefinition>? updateMetaDefs,
  }) {
    state = state.copyWith(
      languageData: state.languageData
          .copyWith(languages: updateLanguages, metas: updateMetaDefs),
    );
  }

  ///////////////////////////////////////////////
  // Methods related to project file class
  ///////////////////////////////////////////////
  void setPath(String path) {
    logger.i('Setting translation relative path: $path');
    state = state.copyWith(file: state.file.copyWith(path: path));
  }

  void setBaseLanguage(String? languageKey) {
    logger.i('Setting base language: $languageKey');
    state =
        state.copyWith(file: state.file.copyWith(baseLanguage: languageKey));
  }

  Future<void> saveProjectFile(String filePath) async {
    logger.i('Saving project to file');
    logger.d('$state');

    final Map<String, String> data = state.file.toMap();
    final File file = File(filePath);
    await fileService.writeFile(file, data);
  }

  // TODO absolut and relative pathes
  Future<List<Map<String, dynamic>>?> loadProjectFileAndTranslations(
    File file,
  ) async {
    logger.i('Loading project');

    final Map<String, dynamic>? data = await fileService.readJsonFromFile(file);

    if (data == null) {
      logger.w('Loading project failed ${file.path}');
      ref.read(notificationController.notifier).add(
            'Loading failed',
            'See logs for more info',
            InfoBarSeverity.error,
          );
      return null;
    }

    final ProjectFile project = ProjectFile.fromMap(data);

    // load all meta files and their content
    if (project.path == null || project.path!.isEmpty) {
      logger.i('Skipping loading translations, as no path was provided');
      return null;
    }

    var res = await fileService.readFilesFromDirectory(project.path!);

    if (res.error != null) {
      logger.w('Loading project files failed: ${file.path}');
      ref.read(notificationController.notifier).add(
            'Loading failed',
            res.error!,
            InfoBarSeverity.error,
          );
      return null;
    }

    return res.files;
  }

  // Undo / Redo states
  @override
  set state(ProjectState value) {
    _historyIndex++;

    // clear everything from the current index upwords
    _history = _history.sublist(0, _historyIndex);

    // add the new entry
    _history.add(value);
    super.state = value;
  }

  bool get canUndo => _historyIndex > 0;

  void undo() {
    if (canUndo) {
      _historyIndex--;

      super.state = _history.elementAt(_historyIndex);
    }
  }

  bool get canRedo => _historyIndex < _history.length - 1;

  void redo() {
    if (canRedo) {
      _historyIndex++;

      super.state = _history.elementAt(_historyIndex);
    }
  }

  void _clearHistory() {
    _historyIndex = -1;
    _history.clear();
  }
}
