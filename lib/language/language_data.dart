import 'package:flutter/foundation.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/language/language.dart';

/// Holds the state of the currently loaded project
@immutable
class LanguageData {
  final Map<String, Language> languages; // langCode
  final Map<String, ArbDefinition> arbDefinitions; // translation key

  LanguageData({Map<String, Language>? existingLanguages, Map<String, ArbDefinition>? existingArdbDefinitions})
      : languages = existingLanguages ?? <String, Language>{},
        arbDefinitions = existingArdbDefinitions ?? <String, ArbDefinition>{};

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

  LanguageData copyWith({
    Map<String, Language>? languages,
    Map<String, ArbDefinition>? arbDefinitions,
  }) {
    return LanguageData(
      existingLanguages: languages ?? this.languages,
      existingArdbDefinitions: arbDefinitions ?? this.arbDefinitions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LanguageData &&
        mapEquals(other.languages, languages) &&
        mapEquals(other.arbDefinitions, arbDefinitions);
  }

  @override
  int get hashCode {
    return languages.hashCode ^ arbDefinitions.hashCode;
  }
}
