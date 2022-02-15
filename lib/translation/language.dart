class Language {
  Language({required this.locale, Map<String, String>? existingTranslations})
      : translations = existingTranslations ?? {};

  factory Language.copyEmpty(String lang, Language base) {
    final Map<String, String> newLang = {...base.translations}; // copy translations
    newLang.updateAll((key, value) => value = ''); // remove all values
    return Language(locale: lang, existingTranslations: newLang);
  }

  final String locale;
  final Map<String, String> translations;

  // TODO translation not available?
  String getTranslation(String key) {
    return translations[key]!;
  }

  /// Adds a new translation, returns false when key already exists
  bool addTranslation(String key, String newTranslation) {
    if (translations.containsKey(key)) {
      return false;
    }
    translations[key] = newTranslation;
    return true;
  }

  void deleteTranslation(String key) {
    translations.remove(key);
  }
}
