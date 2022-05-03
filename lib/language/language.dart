import 'package:flutter/foundation.dart';

@immutable
class Language {
  final Map<String, String> translations;

  Language({Map<String, String>? existingTranslations})
      : translations = existingTranslations ?? {};

  Language copyWith({
    Map<String, String>? translations,
  }) {
    return Language(
      existingTranslations: translations ?? this.translations,
    );
  }

  String getTranslation(String key) {
    return translations[key]!;
  }

  int getTranslationCount() {
    return translations.length;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Language && mapEquals(other.translations, translations);
  }

  @override
  int get hashCode => translations.hashCode;
}
