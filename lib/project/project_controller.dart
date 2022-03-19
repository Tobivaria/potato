import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../arb/arb_definition.dart';
import '../language/language.dart';
import '../potato_logger.dart';
import 'project_state.dart';

final Provider<Map<String, ArbDefinition>> arbDefinitionProvider =
    Provider<Map<String, ArbDefinition>>((ProviderRef<Map<String, ArbDefinition>> ref) {
  return ref.watch(projectProvider).arbDefinitions;
});

final Provider<List<String>> languageListProvider = Provider<List<String>>((ProviderRef<List> ref) {
  return ref.watch(projectProvider).languages.keys.toList();
});

final StateNotifierProvider<ProjectController, ProjectState> projectProvider =
    StateNotifierProvider<ProjectController, ProjectState>(
        (StateNotifierProviderRef<ProjectController, ProjectState> ref) {
  return ProjectController(ref.watch(loggerProvider));
});

class ProjectController extends StateNotifier<ProjectState> {
  ProjectController(this._logger, [ProjectState? init]) : super(init ?? ProjectState());

  final Logger _logger;

  // TODO still needed?
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
}
