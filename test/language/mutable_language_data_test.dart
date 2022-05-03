import 'package:flutter_test/flutter_test.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/language/language.dart';
import 'package:potato/language/language_data.dart';
import 'package:potato/language/mutable_language_data.dart';

void main() {
  late LanguageData languageData;

  setUp(() {
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };

    final Map<String, ArbDefinition> arbDefinitions = {
      'greeting': const ArbDefinition(description: 'Saying hello')
    };

    languageData = LanguageData(
      existingLanguages: languages,
      existingArdbDefinitions: arbDefinitions,
    );
  });

  test(
      'Adding a new language, creates a new language entry with the already existing translations, but empty',
      () {
    final LanguageData actual = languageData.addLanguage('es');

    expect(actual.languages.length, 3);

    final Map<String, String> translations =
        actual.languages['es']!.translations;
    expect(translations.length, 1);
    expect(translations['greeting'], '');
  });

  test(
    'Removing a language, removes also all of its translations',
    () {
      final LanguageData actual = languageData.removeLanguage('en');

      expect(actual.languages.length, 1);
      expect(actual.languages.keys, ['de']);
    },
  );

  test(
      'Adding a key, adds a new map default entry for each language and arb definition',
      () {
    final LanguageData actual = languageData.addKey();
    expect(actual.languages['en']!.translations.length, 2);
    expect(actual.languages['de']!.translations.length, 2);
    expect(actual.arbDefinitions.length, 2);

    expect(actual.languages['en']!.translations['@Addkey'], '');
    expect(actual.languages['de']!.translations['@Addkey'], '');
    expect(
      actual.arbDefinitions['@Addkey'],
      const ArbDefinition(),
    );
  });

  test('Removing a key, remove the key from translation and arb definition',
      () {
    final LanguageData actual = languageData.removeKey('greeting');
    expect(actual.languages['en']!.translations.length, 0);
    expect(actual.languages['de']!.translations.length, 0);
    expect(actual.arbDefinitions.length, 0);
  });

  test(
      'Expect key to update all corresponding keys in arb definition and languages',
      () {
    final LanguageData actual = languageData.updateKey('greeting', 'bye');

    // length does not change
    expect(actual.languages['en']!.translations.length, 1);
    expect(actual.languages['de']!.translations.length, 1);
    expect(actual.arbDefinitions.length, 1);

    expect(actual.languages['en']!.translations['bye'], 'hello');
    expect(actual.languages['de']!.translations['bye'], 'hallo');
    expect(
      actual.arbDefinitions['bye'],
      const ArbDefinition(description: 'Saying hello'),
    );
  });

  test('Adding a descriptions to the definition', () {
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };

    final Map<String, ArbDefinition> arbDefinitions = {
      'greeting': const ArbDefinition()
    };

    languageData = LanguageData(
      existingLanguages: languages,
      existingArdbDefinitions: arbDefinitions,
    );

    final LanguageData actual = languageData.addDescription('greeting');

    expect(
      actual.arbDefinitions['greeting']!.description,
      '',
    );
  });

  test('Removing a descriptions of the definition', () {
    final LanguageData actual = languageData.removeDescription('greeting');
    expect(
      actual.arbDefinitions['greeting']!.description,
      isNull,
    );
  });

  test('Updating a descriptions of the definition', () {
    final LanguageData actual =
        languageData.updateDescription('greeting', 'Go home!');
    expect(
      actual.arbDefinitions['greeting']!.description,
      'Go home!',
    );
    expect(
      actual.arbDefinitions['greeting']!.placeholders,
      isNull,
    );
  });

  test('Expect a translation to update for the correct language', () {
    final LanguageData expected = LanguageData(
      existingArdbDefinitions: const {
        'greeting': ArbDefinition(description: 'Saying hello'),
      },
      existingLanguages: {
        'en': Language(existingTranslations: const {'greeting': 'hello'}),
        'de': Language(existingTranslations: const {'greeting': 'Servus'}),
      },
    );

    final LanguageData actual =
        languageData.updateTranslation('de', 'greeting', 'Servus');

    expect(actual, expected);
  });
}
