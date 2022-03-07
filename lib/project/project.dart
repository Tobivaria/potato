import 'package:flutter/foundation.dart';

import '../language/language.dart';
import '../translation/arb_definition.dart';

@immutable
class Project {
  final String baseLanguage;
  final String? path;
  final Map<String, Language> languages; // langCode
  final Map<String, ArbDefinition> arbDefinitions; // translation key
  static const String _projectVersion = '1';

  Project(
      {required this.baseLanguage,
      this.path,
      Map<String, Language>? existingLanguages,
      Map<String, ArbDefinition>? existingArdbDefinitions})
      : languages = existingLanguages ?? <String, Language>{},
        arbDefinitions = existingArdbDefinitions ?? <String, ArbDefinition>{} {
    languages.putIfAbsent(baseLanguage, () => Language());
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      baseLanguage: map['baseLanguage'] ?? '', // TODO assert when baselanguage not found
      path: map['path'],
    );
  }

  Map<String, String> toMap() {
    return {'baseLanguage': baseLanguage, 'path': path ?? '', 'version': _projectVersion};
  }

  List<String> supportedLanguages() {
    return languages.keys.toList();
  }

  /// Creates a ordered map of the given language key, in the arb format
  Map<String, dynamic> exportLanguage(String langKey, List<String> keyOrder) {
    Map<String, dynamic> export = <String, dynamic>{'@@locale': langKey};
    if (langKey == baseLanguage) {
      var baseTranslations = languages[langKey]!.translations;
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

  Project copyWith({
    String? baseLang,
    String? path,
    Map<String, Language>? languages,
    Map<String, ArbDefinition>? arbDefinitions,
  }) {
    return Project(
      baseLanguage: baseLang ?? baseLanguage,
      path: path ?? this.path,
      existingLanguages: languages ?? this.languages,
      existingArdbDefinitions: arbDefinitions ?? this.arbDefinitions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Project &&
        other.baseLanguage == baseLanguage &&
        other.path == path &&
        mapEquals(other.languages, languages) &&
        mapEquals(other.arbDefinitions, arbDefinitions);
  }

  @override
  int get hashCode {
    return baseLanguage.hashCode ^ path.hashCode ^ languages.hashCode ^ arbDefinitions.hashCode;
  }
}
