import 'package:flutter/foundation.dart';

@immutable
class TranslationConfig {
  final String targetLang;
  final String sourceLang;

  /// Translate to informal language
  final String? formality;

  const TranslationConfig({
    required this.targetLang,
    required this.sourceLang,
    this.formality,
  });
}
