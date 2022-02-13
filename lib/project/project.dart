import '../translation/language.dart';

class Project {
  Project(this.baseLanaguage, this.path) : _languages = <String, Language>{} {
    _languages[baseLanaguage] = Language(locale: baseLanaguage);
  }

  factory Project.fromSerialized(Map<String, dynamic> data) {
    return Project(data['baseLanguage']!, data['projectPath']!);
  }

  String baseLanaguage;
  String path;
  final Map<String, Language> _languages;
  static const _projectVersion = '1.0';

  List<String> supportedLanguages() {
    return _languages.keys.toList();
  }

  /// Add a new language to the project, returns false when language already exists
  bool addLanguage(String newLang) {
    if (_languages.containsKey(newLang)) {
      return false;
    }
    _languages[newLang] = Language.copyEmpty(newLang, _languages[baseLanaguage]!);
    return true;
  }

  // Remove an existing language from the project
  void removeLanguage(String langToRemove) {
    _languages.remove(langToRemove);
  }

  Map<String, String> toMap() {
    return <String, String>{'version': _projectVersion, 'projectPath': path, 'baseLanguage': baseLanaguage};
  }
}
