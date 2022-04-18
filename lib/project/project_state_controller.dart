import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/language/language.dart';
import 'package:potato/notification/notification_controller.dart';
import 'package:potato/project/project_file.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/utils/potato_logger.dart';

/// Abosult path of the potato project file
final StateProvider<String> abosultProjectPath = StateProvider<String>(
  (ref) => '',
);

/// Abosult path of the translation files
final StateProvider<String> abosultTranslationPath = StateProvider<String>(
  (ref) => '',
);

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
  ProjectStateController(this.fileService, this.logger, this.ref,
      [ProjectState? init])
      : super(init ?? ProjectState());

  final FileService fileService;
  final Logger logger;
  Ref ref;

  void loadfromJsons(List<Map<String, dynamic>> data) {
    final Map<String, ArbDefinition> arbDefinitions = {};
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
          arbDefinitions[key.substring(1)] =
              ArbDefinition.fromMap(item as Map<String, dynamic>);
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
    state = state.copyWith(
      languageData: state.languageData
          .copyWith(arbDefinitions: arbDefinitions, languages: languages),
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

    final Map<String, String> newLanguage = {};
    for (final entry in state.languageData.arbDefinitions.keys) {
      newLanguage[entry] = '';
    }

    state = state.copyWith(
      languageData: state.languageData.copyWith(
        languages: {
          ...state.languageData.languages,
          langKey: Language(existingTranslations: newLanguage)
        },
      ),
    );
  }

  /// Remove an existing language from the project
  void removeLanguage(String langToRemove) {
    logger.d('Removing language: $langToRemove');

    final Map<String, Language> previousLanguages = {
      ...state.languageData.languages
    };
    previousLanguages.remove(langToRemove);
    state = state.copyWith(
      languageData: state.languageData.copyWith(languages: previousLanguages),
    );

    if (langToRemove == state.file.baseLanguage) {
      // invalidate base language
      setBaseLanguage(null);
    }
  }

  /// Adds a new translation with given key
  /// When no key is given a predefined key is used
  void addTranslation({String? key, String? translation}) {
    const String emptyKey = '@Add key';
    String keyToInsert = key ?? emptyKey;

    // TODO add test for that part
    if (key == null) {
      // as the key needs to be unique for new entries, increment count
      final RegExp reg = RegExp(r'\d+');
      while (state.languageData.arbDefinitions.keys.contains(keyToInsert)) {
        final RegExpMatch? match = reg.firstMatch(keyToInsert);

        if (match == null) {
          // no number previously attached
          keyToInsert += '1';
          continue;
        }
        final String? intStr = match.group(0);

        keyToInsert = '$emptyKey ${(int.tryParse(intStr!) ?? 0) + 1}';
      }
    }

    final Map<String, Language> modifiedLanguages = {};

    for (final item in state.languageData.languages.keys) {
      modifiedLanguages[item] = Language(
        existingTranslations: {
          ...state.languageData.languages[item]!.translations,
          keyToInsert: ''
        },
      );
    }
    state = state.copyWith(
      languageData: state.languageData.copyWith(
        languages: modifiedLanguages,
        arbDefinitions: {
          ...state.languageData.arbDefinitions,
          keyToInsert: const ArbDefinition()
        },
      ),
    );
  }

  void removeTranslation(String keyToRemove) {
    logger.d('Removing translation with key: $keyToRemove');

    final Map<String, Language> modifiedLanguages = {};

    for (final key in state.languageData.languages.keys) {
      final Map<String, String> copy =
          Map.of(state.languageData.languages[key]!.translations);
      copy.remove(keyToRemove);
      modifiedLanguages[key] = Language(existingTranslations: copy);
    }

    final Map<String, ArbDefinition> arbDefs = {
      ...state.languageData.arbDefinitions
    };
    arbDefs.remove(keyToRemove);
    state = state.copyWith(
      languageData: state.languageData
          .copyWith(languages: modifiedLanguages, arbDefinitions: arbDefs),
    );
  }

  Future<void> export(String pathToExportTo) async {
    final List<String> keys = state.languageData.arbDefinitions.keys.toList();
    // sort keys alphabetically
    keys.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    for (final item in state.languageData.languages.keys) {
      final data = state.languageData.exportLanguage(item, keys);
      final File file = File('$pathToExportTo/app_$item.arb');
      await fileService.writeFile(file, data);
    }
  }

  /// Updates the key in the arb definition and all languages
  void updateKey(String oldKey, String newKey) {
    logger.d('Updating key from "$oldKey" to "$newKey"');

    if (state.languageData.arbDefinitions.containsKey(newKey)) {
      logger.w('Key already exists and cannot be renamed');
      ref.read(notificationController.notifier).add(
            'Duplicate key',
            '$newKey as key already exists',
            InfoBarSeverity.error,
          );
      return;
    }

    final Map<String, Language> modifiedLanguages = {};

    for (final languageKey in state.languageData.languages.keys) {
      final Map<String, String> copy =
          Map.of(state.languageData.languages[languageKey]!.translations);
      final String removedTranslation = copy.remove(oldKey)!;
      copy[newKey] = removedTranslation;
      modifiedLanguages[languageKey] = Language(existingTranslations: copy);
    }

    final Map<String, ArbDefinition> arbDefs = {
      ...state.languageData.arbDefinitions
    };
    final ArbDefinition removedDef = arbDefs.remove(oldKey)!;
    arbDefs[newKey] = removedDef;

    state = state.copyWith(
      languageData: state.languageData
          .copyWith(languages: modifiedLanguages, arbDefinitions: arbDefs),
    );
  }

  void updateTranslation(String langKey, String key, String translation) {
    logger.d(
      'Updating translation for "$langKey" entry "$key" to "$translation"',
    );

    final Map<String, Language> modifiedLanguages = {};

    for (final languageKey in state.languageData.languages.keys) {
      final Map<String, String> copy =
          Map.of(state.languageData.languages[languageKey]!.translations);
      if (languageKey == langKey) {
        copy[key] = translation;
      }
      modifiedLanguages[languageKey] = Language(existingTranslations: copy);
    }

    state = state.copyWith(
      languageData: state.languageData.copyWith(languages: modifiedLanguages),
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
      File file) async {
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

    // load all arb files and their content
    if (project.path == null || project.path!.isEmpty) {
      logger.i('Skipping loading translations, as no path was provided');
      return null;
    }

    return fileService.readFilesFromDirectory(project.path!);
  }
}
