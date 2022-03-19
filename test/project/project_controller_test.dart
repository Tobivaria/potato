import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/language/language.dart';
import 'package:potato/potato_logger.dart';
import 'package:potato/project/project_controller.dart';
import 'package:potato/project/project_state.dart';

import '../mocks.dart';

void main() {
  late ProviderContainer container;
  late Logger logger;

  setUp(() {
    logger = MockLogger();
    container = ProviderContainer(overrides: [
      loggerProvider.overrideWithValue(logger),
    ]);

    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };
    final Map<String, ArbDefinition> arbDefinitions = {
      'greeting': const ArbDefinition(description: 'Some description')
    };
    container
        .read(projectProvider.notifier)
        .setProjectState(ProjectState(existingArdbDefinitions: arbDefinitions, existingLanguages: languages));
  });

  tearDown(() {
    container.dispose();
  });

  test('Adding a new language, creates a new language entry with the already existing translations, but empty', () {
    container.read(projectProvider.notifier).addLanguage('es');
    ProjectState projectState = container.read(projectProvider);
    expect(projectState.languages.length, 3);

    Map<String, String> translations = projectState.languages['es']!.translations;
    expect(translations.length, 1);
    expect(translations['greeting'], '');
  });

  test('Remove language', () {
    container.read(projectProvider.notifier).removeLanguage('en');

    ProjectState projectState = container.read(projectProvider);
    expect(projectState.languages.length, 1);
    expect(projectState.languages.keys, ['de']);
  });

  test('Adding a translation, adds a new map entry for each language and arb definition', () {
    container.read(projectProvider.notifier).addTranslation(key: 'food');
    ProjectState projectState = container.read(projectProvider);
    expect(projectState.languages['en']!.translations.length, 2);
    expect(projectState.languages['de']!.translations.length, 2);
    expect(projectState.arbDefinitions.length, 2);

    expect(projectState.languages['en']!.translations['food'], '');
    expect(projectState.languages['de']!.translations['food'], '');
    expect(projectState.arbDefinitions['food'], const ArbDefinition());
  });
  test('Removing a translation, remove the key from translation and arb definition', () {
    container.read(projectProvider.notifier).removeTranslation('greeting');
    ProjectState projectState = container.read(projectProvider);
    expect(projectState.languages['en']!.translations.length, 0);
    expect(projectState.languages['de']!.translations.length, 0);
    expect(projectState.arbDefinitions.length, 0);
  });
}
