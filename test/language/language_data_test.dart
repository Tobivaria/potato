import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/language/language.dart';
import 'package:potato/language/language_data.dart';

void main() {
  test('Create new language data', () {
    final LanguageData data = LanguageData();
    expect(mapEquals(data.languages, {}), isTrue);
    expect(mapEquals(data.arbDefinitions, {}), isTrue);
  });

  test('Copy language data', () {
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };
    final Map<String, ArbDefinition> arbDefinitions = {
      'greeting': const ArbDefinition(description: 'Lul')
    };

    final LanguageData data = LanguageData();
    final LanguageData copy =
        data.copyWith(languages: languages, arbDefinitions: arbDefinitions);

    expect(copy.languages, languages);
    expect(mapEquals(copy.languages, languages), isTrue);
    expect(mapEquals(copy.arbDefinitions, arbDefinitions), isTrue);
  });

  test('Return available language list', () {
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };

    final LanguageData data = LanguageData(existingLanguages: languages);

    expect(listEquals(data.supportedLanguages(), ['en', 'de']), isTrue);
  });

  test('Export a language entry', () {
    final Map<String, Language> languages = {
      'en': Language(
        existingTranslations: const {'greeting': 'hello', 'bye': 'goodbye'},
      ),
      'de': Language(
        existingTranslations: const {'greeting': 'hallo', 'bye': 'tschüss'},
      )
    };

    final LanguageData project = LanguageData(existingLanguages: languages);
    const Map<String, dynamic> expected = {
      '@@locale': 'de',
      'bye': 'tschüss',
      'greeting': 'hallo'
    };

    expect(project.exportLanguage('de', ['bye', 'greeting']), expected);
  });

  test('Export base language', () {
    final Map<String, Language> languages = {
      'en': Language(
        existingTranslations: const {'greeting': 'hello', 'bye': 'goodbye'},
      ),
      'de': Language(
        existingTranslations: const {'greeting': 'hallo', 'bye': 'tschüss'},
      )
    };
    final Map<String, ArbDefinition> arbDefinitions = {
      'bye': const ArbDefinition(description: 'Saying goodbye'),
      'greeting': const ArbDefinition(description: 'Saying hello')
    };

    final LanguageData data = LanguageData(
      existingLanguages: languages,
      existingArdbDefinitions: arbDefinitions,
    );

    const Map<String, dynamic> expected = {
      '@@locale': 'en',
      'bye': 'goodbye',
      '@bye': {'description': 'Saying goodbye'},
      'greeting': 'hello',
      '@greeting': {'description': 'Saying hello'}
    };

    expect(
      data.exportLanguage('en', ['bye', 'greeting'], isMainLanguage: true),
      expected,
    );
  });
}
