import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/language/language.dart';
import 'package:potato/potato_logger.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/project/project_state_controller.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  late ProviderContainer container;
  late FileService mockFileService;
  late Logger mockLogger;

  setUpAll(() {
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    mockLogger = MockLogger();
    mockFileService = MockFileService();
    container = ProviderContainer(
      overrides: [
        fileServiceProvider.overrideWithValue(mockFileService),
        loggerProvider.overrideWithValue(mockLogger),
      ],
    );

    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };
    final Map<String, ArbDefinition> arbDefinitions = {
      'greeting': const ArbDefinition(description: 'Some description')
    };
    container
        .read(projectStateProvider.notifier)
        .setProjectState(ProjectState(existingArdbDefinitions: arbDefinitions, existingLanguages: languages));
  });

  tearDown(() {
    container.dispose();
  });

  test('Adding a new language, creates a new language entry with the already existing translations, but empty', () {
    container.read(projectStateProvider.notifier).addLanguage('es');
    final ProjectState projectState = container.read(projectStateProvider);
    expect(projectState.languages.length, 3);

    final Map<String, String> translations = projectState.languages['es']!.translations;
    expect(translations.length, 1);
    expect(translations['greeting'], '');
  });

  test('Remove language', () {
    container.read(projectStateProvider.notifier).removeLanguage('en');

    final ProjectState projectState = container.read(projectStateProvider);
    expect(projectState.languages.length, 1);
    expect(projectState.languages.keys, ['de']);
  });

  test('Adding a translation, adds a new map entry for each language and arb definition', () {
    container.read(projectStateProvider.notifier).addTranslation(key: 'food');
    final ProjectState projectState = container.read(projectStateProvider);
    expect(projectState.languages['en']!.translations.length, 2);
    expect(projectState.languages['de']!.translations.length, 2);
    expect(projectState.arbDefinitions.length, 2);

    expect(projectState.languages['en']!.translations['food'], '');
    expect(projectState.languages['de']!.translations['food'], '');
    expect(projectState.arbDefinitions['food'], const ArbDefinition());
  });

  test('Removing a translation, remove the key from translation and arb definition', () {
    container.read(projectStateProvider.notifier).removeTranslation('greeting');
    final ProjectState projectState = container.read(projectStateProvider);
    expect(projectState.languages['en']!.translations.length, 0);
    expect(projectState.languages['de']!.translations.length, 0);
    expect(projectState.arbDefinitions.length, 0);
  });

  test('Export every language and its translations to a separate file', () async {
    when(() => mockFileService.writeFile(any(), any())).thenAnswer((_) async {});
    await container.read(projectStateProvider.notifier).export('some/path');

    verify(() => mockFileService.writeFile(any(), any())).called(2);
  });
}
