import 'package:flutter/foundation.dart';

@immutable
class Language {
  const Language({required this.locale, this.translations = const {}});

  factory Language.copyEmpty(String lang, Language base) {
    final Map<String, String> newLang = {...base.translations}; // copy translations
    base.translations.updateAll((key, value) => value = ''); // remove all values
    return Language(locale: lang, translations: newLang);
  }

  final String locale;
  final Map<String, String> translations;

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


// {
//   "@@locale": "en",
//   "aboutCopyright": "The content of this application may not be duplicated, distributed, changed, or made accessible to third parties in any form beyond the confines of copyright law. Content in terms of the underlying applications is defined as design, the logos, graphics, as well as animations.",
//   "@aboutCopyright": {
//     "type": "String",
//     "description": "Copyright notice text"
//   },
