import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../arb/arb_definition.dart';
import '../file_handling/file_service.dart';
import '../language/language.dart';
import '../potato_logger.dart';
import 'project_state.dart';

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
  return ProjectStateController(ref.watch(fileServiceProvider), ref.watch(loggerProvider));
});

class ProjectStateController extends StateNotifier<ProjectState> {
  ProjectStateController(this._fileService, this._logger, [ProjectState? init]) : super(init ?? ProjectState());

  final FileService _fileService;
  final Logger _logger;

  void setProjectState(ProjectState project) {
    state = project;
  }

  void addLanguage(String langKey) {
    _logger.d('Adding language: $langKey');

    // TODO define base language on project create
    if (state.languages.isEmpty) {
      return;
    }

    Map<String, String> newLanguage = {};
    for (var entry in state.arbDefinitions.keys) {
      newLanguage[entry] = '';
    }

    state = state.copyWith(languages: {...state.languages, langKey: Language(existingTranslations: newLanguage)});
  }

  /// Remove an existing language from the project
  void removeLanguage(String langToRemove) {
    _logger.d('Removing language: $langToRemove');

    Map<String, Language> previousLanguages = {...state.languages};
    previousLanguages.remove(langToRemove);
    state = state.copyWith(languages: previousLanguages);
  }

  void addTranslation({required String key, String? translation}) {
    final Map<String, Language> modifiedLanguages = {};

    for (var item in state.languages.keys) {
      modifiedLanguages[item] = Language(existingTranslations: {...state.languages[item]!.translations, key: ''});
    }
    state = state
        .copyWith(languages: modifiedLanguages, arbDefinitions: {...state.arbDefinitions, key: const ArbDefinition()});
  }

  void removeTranslation(String keyToRemove) {
    _logger.d('Removing translation with key: $keyToRemove');

    Map<String, Language> modifiedLanguages = {};

    for (var key in state.languages.keys) {
      Map<String, String> copy = Map.of(state.languages[key]!.translations);
      copy.remove(keyToRemove);
      modifiedLanguages[key] = Language(existingTranslations: copy);
    }

    Map<String, ArbDefinition> arbDefs = {...state.arbDefinitions};
    arbDefs.remove(keyToRemove);
    state = state.copyWith(languages: modifiedLanguages, arbDefinitions: arbDefs);
  }

  Future<void> export(String pathToExportTo) async {
    List<String> keys = state.arbDefinitions.keys.toList();
    // sort keys alphabetically
    keys.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    for (var item in state.languages.keys) {
      var data = state.exportLanguage(item, keys);
      final File file = File('$pathToExportTo/app_$item.arb');
      await _fileService.writeFile(file, data);
    }
  }
}
