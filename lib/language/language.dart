import 'package:flutter/foundation.dart';

@immutable
class Language {
  final Map<String, String> translations;

  Language({Map<String, String>? existingTranslations}) : translations = existingTranslations ?? {};

  factory Language.copyEmpty(Language base) {
    final Map<String, String> newLang = {...base.translations}; // copy translations
    newLang.updateAll((key, value) => ''); // remove all values
    return Language(existingTranslations: newLang);
  }

  Language copyWith({
    Map<String, String>? translations,
  }) {
    return Language(
      existingTranslations: translations ?? this.translations,
    );
  }

  // TODO translation not available?
  String getTranslation(String key) {
    return translations[key]!;
  }

  int getTranslationCount() {
    return translations.length;
  }

  /// Adds a new translation, returns false when key already exists
  bool addTranslation(String key, String? newTranslation) {
    if (translations.containsKey(key)) {
      return false;
    }
    translations[key] = '';
    return true;
  }

  void deleteTranslation(String key) {
    translations.remove(key);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Language && mapEquals(other.translations, translations);
  }

  @override
  int get hashCode => translations.hashCode;
}
