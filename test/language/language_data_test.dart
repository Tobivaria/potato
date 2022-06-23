import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/language/language.dart';
import 'package:potato/language/language_data.dart';
import 'package:potato/meta/meta_definition.dart';

void main() {
  test('Create new language data', () {
    final LanguageData data = LanguageData();
    expect(mapEquals(data.languages, {}), isTrue);
    expect(mapEquals(data.metaDefinitions, {}), isTrue);
  });

  test('Copy language data', () {
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };
    final Map<String, MetaDefinition> metaDefinitions = {
      'greeting': const MetaDefinition(description: 'Lul')
    };

    final LanguageData data = LanguageData();
    final LanguageData copy =
        data.copyWith(languages: languages, metas: metaDefinitions);

    expect(copy.languages, languages);
    expect(mapEquals(copy.languages, languages), isTrue);
    expect(mapEquals(copy.metaDefinitions, metaDefinitions), isTrue);
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
    final Map<String, MetaDefinition> metaDefinitions = {
      'bye': const MetaDefinition(description: 'Saying goodbye'),
      'greeting': const MetaDefinition(description: 'Saying hello')
    };

    final LanguageData data = LanguageData(
      existingLanguages: languages,
      existingArdbDefinitions: metaDefinitions,
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
