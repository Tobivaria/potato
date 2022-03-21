import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/language/language.dart';
import 'package:potato/potato_logger.dart';
import 'package:potato/project/project_file_controller.dart';
import 'package:potato/project/project_state.dart';

final Provider<Map<String, ArbDefinition>> arbDefinitionProvider =
    Provider<Map<String, ArbDefinition>>((ProviderRef<Map<String, ArbDefinition>> ref) {
  return ref.watch(projectStateProvider).arbDefinitions;
});

final Provider<List<String>> languageListProvider = Provider<List<String>>((ProviderRef<List> ref) {
  return ref.watch(projectStateProvider).languages.keys.toList();
});

final StateNotifierProvider<ProjectStateController, ProjectState> projectStateProvider =
    StateNotifierProvider<ProjectStateController, ProjectState>(
        (StateNotifierProviderRef<ProjectStateController, ProjectState> ref) {
  return ProjectStateController(
    ref.watch(fileServiceProvider),
    ref.watch(projectFileProvider.notifier),
    ref.watch(loggerProvider),
  );
});

class ProjectStateController extends StateNotifier<ProjectState> {
  ProjectStateController(this._fileService, this._projectFileController, this._logger, [ProjectState? init])
      : super(init ?? ProjectState());

  final FileService _fileService;
  final ProjectFileController _projectFileController;
  final Logger _logger;

  void setProjectState(ProjectState project) {
    state = project;
  }

  void addLanguage(String langKey) {
    _logger.d('Adding language: $langKey');

    if (state.languages.isEmpty) {
      // mark first language as base language

      _projectFileController.setBaseLanguage(langKey);
    }

    final Map<String, String> newLanguage = {};
    for (final entry in state.arbDefinitions.keys) {
      newLanguage[entry] = '';
    }

    state = state.copyWith(languages: {...state.languages, langKey: Language(existingTranslations: newLanguage)});
  }

  /// Remove an existing language from the project
  void removeLanguage(String langToRemove) {
    _logger.d('Removing language: $langToRemove');

    final Map<String, Language> previousLanguages = {...state.languages};
    previousLanguages.remove(langToRemove);
    state = state.copyWith(languages: previousLanguages);

    if (langToRemove == _projectFileController.state.baseLanguage) {
      // invalidate base language
      _projectFileController.setBaseLanguage(null);
    }
  }

  void addTranslation({required String key, String? translation}) {
    final Map<String, Language> modifiedLanguages = {};

    for (final item in state.languages.keys) {
      modifiedLanguages[item] = Language(existingTranslations: {...state.languages[item]!.translations, key: ''});
    }
    state = state
        .copyWith(languages: modifiedLanguages, arbDefinitions: {...state.arbDefinitions, key: const ArbDefinition()});
  }

  void removeTranslation(String keyToRemove) {
    _logger.d('Removing translation with key: $keyToRemove');

    final Map<String, Language> modifiedLanguages = {};

    for (final key in state.languages.keys) {
      final Map<String, String> copy = Map.of(state.languages[key]!.translations);
      copy.remove(keyToRemove);
      modifiedLanguages[key] = Language(existingTranslations: copy);
    }

    final Map<String, ArbDefinition> arbDefs = {...state.arbDefinitions};
    arbDefs.remove(keyToRemove);
    state = state.copyWith(languages: modifiedLanguages, arbDefinitions: arbDefs);
  }

  Future<void> export(String pathToExportTo) async {
    final List<String> keys = state.arbDefinitions.keys.toList();
    // sort keys alphabetically
    keys.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    for (final item in state.languages.keys) {
      final data = state.exportLanguage(item, keys);
      final File file = File('$pathToExportTo/app_$item.arb');
      await _fileService.writeFile(file, data);
    }
  }
}
