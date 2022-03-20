import 'package:flutter/foundation.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/language/language.dart';

/// Holds the state of the currently loaded project
@immutable
class ProjectState {
  final Map<String, Language> languages; // langCode
  final Map<String, ArbDefinition> arbDefinitions; // translation key

  ProjectState({Map<String, Language>? existingLanguages, Map<String, ArbDefinition>? existingArdbDefinitions})
      : languages = existingLanguages ?? <String, Language>{},
        arbDefinitions = existingArdbDefinitions ?? <String, ArbDefinition>{};

  factory ProjectState.fromJsons(List<Map<String, dynamic>> data) {
    final Map<String, ArbDefinition> arbDefinitions = {};
    final Map<String, Language> languages = {};

    // TODO error handling

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
          arbDefinitions[key.substring(1)] = ArbDefinition.fromMap(item as Map<String, dynamic>);
        } else {
          translations[key] = item as String;
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
  Map<String, dynamic> exportLanguage(String langKey, List<String> keyOrder, {bool isBaseLanguage = false}) {
    final Map<String, dynamic> export = <String, dynamic>{'@@locale': langKey};
    if (isBaseLanguage) {
      final Map<String, String> baseTranslations = languages[langKey]!.translations;
      // add one key after the other
      for (final String key in keyOrder) {
        export[key] = baseTranslations[key];
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
