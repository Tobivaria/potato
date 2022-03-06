import 'package:flutter/foundation.dart';

import '../language/language.dart';
import '../translation/arb_definition.dart';

@immutable
class Project {
  Project(
      {required this.baseLanguage,
      this.path,
      Map<String, Language>? existingLanguages,
      Map<String, ArbDefinition>? existingArdbDefinitions})
      : languages = existingLanguages ?? <String, Language>{},
        arbDefinitions = existingArdbDefinitions ?? <String, ArbDefinition>{} {
    languages.putIfAbsent(baseLanguage, () => Language());
  }

  factory Project.fromSerialized(Map<String, dynamic> data) {
    return Project(baseLanguage: data['baseLanguage']!, path: data['projectPath']!);
  }

  final String baseLanguage;
  final String? path;
  final Map<String, Language> languages; // langCode
  final Map<String, ArbDefinition> arbDefinitions; // translation key
  static const _projectVersion = '1.0';

  List<String> supportedLanguages() {
    return languages.keys.toList();
  }

  /// Add a new language to the project, returns false when language already exists
  @Deprecated("Todo delete, as this moved to the project controller")
  bool addLanguage(String newLang) {
    if (languages.containsKey(newLang)) {
      return false;
    }
    languages[newLang] = Language.copyEmpty(languages[baseLanguage]!);
    return true;
  }

  @Deprecated("Todo delete, as this moved to the project controller")
  // Remove an existing language from the project
  void removeLanguage(String langToRemove) {
    languages.remove(langToRemove);
  }

  Map<String, String> toMap() {
    return <String, String>{'version': _projectVersion, 'projectPath': path ?? '', 'baseLanguage': baseLanguage};
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
}
