import 'package:flutter/foundation.dart';

import '../arb/arb_definition.dart';
import '../language/language.dart';

/// Holds the state of the currently loaded project
@immutable
class ProjectState {
  final Map<String, Language> languages; // langCode
  final Map<String, ArbDefinition> arbDefinitions; // translation key

  ProjectState({Map<String, Language>? existingLanguages, Map<String, ArbDefinition>? existingArdbDefinitions})
      : languages = existingLanguages ?? <String, Language>{},
        arbDefinitions = existingArdbDefinitions ?? <String, ArbDefinition>{};

  factory ProjectState.fromJsons(List<Map<String, dynamic>> data) {
    Map<String, ArbDefinition> arbDefinitions = {};
    Map<String, Language> languages = {};

    // TODO error handling

    // iterate over jsons
    for (Map<String, dynamic> entry in data) {
      String locale = '';
      Map<String, String> translations = {};

      // extract data from json
      for (String key in entry.keys) {
        var item = entry[key];
        if (key == '@@locale') {
          locale = item;
        } else if (key.startsWith('@')) {
          arbDefinitions[key.substring(1)] = ArbDefinition.fromMap(item);
        } else {
          translations[key] = item;
        }
      }

      languages[locale] = Language(existingTranslations: translations);
    }

    return ProjectState(existingArdbDefinitions: arbDefinitions, existingLanguages: languages);
  }

  List<String> supportedLanguages() {
    return languages.keys.toList();
  }

  /// Creates a ordered map of the given language key, in the arb format
  Map<String, dynamic> exportLanguage(String langKey, List<String> keyOrder, [bool isBaseLanguage = false]) {
    Map<String, dynamic> export = <String, dynamic>{'@@locale': langKey};
    if (isBaseLanguage) {
      Map<String, String> baseTranslations = languages[langKey]!.translations;
      // add one key after the other
      for (final String key in keyOrder) {
        export[key] = baseTranslations[key]!;
        export['@$key'] = arbDefinitions[key]!.toMap();
      }
    } else {
      for (final String key in keyOrder) {
        export[key] = languages[langKey]!.translations[key];
      }
    }
    return export;
  }

  ProjectState copyWith({
    Map<String, Language>? languages,
    Map<String, ArbDefinition>? arbDefinitions,
  }) {
    return ProjectState(
      existingLanguages: languages ?? this.languages,
      existingArdbDefinitions: arbDefinitions ?? this.arbDefinitions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectState &&
        mapEquals(other.languages, languages) &&
        mapEquals(other.arbDefinitions, arbDefinitions);
  }

  @override
  int get hashCode {
    return languages.hashCode ^ arbDefinitions.hashCode;
  }
}
