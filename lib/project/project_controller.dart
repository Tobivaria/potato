import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../arb/arb_definition.dart';
import '../language/language.dart';
import '../potato_logger.dart';
import 'project.dart';

final Provider<Map<String, ArbDefinition>> arbDefinitionProvider =
    Provider<Map<String, ArbDefinition>>((ProviderRef<Map<String, ArbDefinition>> ref) {
  return ref.watch(projectProvider).arbDefinitions;
});

final Provider<List<String>> languageListProvider = Provider<List<String>>((ProviderRef<List> ref) {
  return ref.watch(projectProvider).languages.keys.toList();
});

final StateNotifierProvider<ProjectController, Project> projectProvider =
    StateNotifierProvider<ProjectController, Project>((StateNotifierProviderRef<ProjectController, Project> ref) {
  return ProjectController(ref.watch(loggerProvider));
});

class ProjectController extends StateNotifier<Project> {
  ProjectController(this._logger, [Project? init]) : super(init ?? Project(baseLanguage: 'en'));

  final Logger _logger;

  void setProject(Project project) {
    state = project;
  }

  void addLanguage(String newLang) {
    _logger.d('Adding language: $newLang');
    state = state
        .copyWith(languages: {...state.languages, newLang: Language.copyEmpty(state.languages[state.baseLanguage]!)});
  }

  /// Remove an existing language from the project
  void removeLanguage(String langToRemove) {
    _logger.d('Removing language: $langToRemove');

    Map<String, Language> previousLanguages = {...state.languages};
    previousLanguages.remove(langToRemove);
    state = state.copyWith(languages: previousLanguages);
  }

  Language getLanguage(String lang) {
    return state.languages[lang]!;
  }

  void addTranslation({required String key, String? translation}) {
    Map<String, Language> newLanguages = {};
    for (var item in state.languages.keys) {
      var tmp = state.languages[item]!;
      tmp.addTranslation(key, translation);
      newLanguages[item] = tmp;
    }
    state = state.copyWith(languages: newLanguages, arbDefinitions: {...state.arbDefinitions, key: ArbDefinition()});
  }

  void removeTranslation(String key) {
    _logger.d('Removing translation with key: $key');

    Map<String, Language> newLanguages = {};
    Map<String, ArbDefinition> arbDefs = {...state.arbDefinitions};
    arbDefs.remove(key);

    for (var item in state.languages.keys) {
      var tmp = state.languages[item]!;
      tmp.deleteTranslation(key);
      newLanguages[item] = tmp;
    }
    state = state.copyWith(languages: newLanguages, arbDefinitions: arbDefs);
  }

  int getTranslationCount() {
    return state.languages[state.baseLanguage]!.getTranslationCount();
  }
}
