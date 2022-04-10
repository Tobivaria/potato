import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/language/language.dart';
import 'package:potato/language/language_data.dart';
import 'package:potato/potato_logger.dart';
import 'package:potato/project/project_file.dart';
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
  });

  tearDown(() {
    container.dispose();
  });

  test('Verify set path and language are working', () {
    container.read(projectStateProvider.notifier).setBaseLanguage('en');
    container.read(projectStateProvider.notifier).setPath('some/path');
    final ProjectFile actual = container.read(projectStateProvider).file;

    expect(actual.baseLanguage, 'en');
    expect(actual.path, 'some/path');
  });

  test('Save project to a file', () async {
    when(() => mockFileService.writeFile(any(), any())).thenAnswer((_) async {});

    await container.read(projectStateProvider.notifier).saveProjectFile('some/path');

    verify(() => mockFileService.writeFile(any(), any())).called(1);
  });

  test('Load project file and all translations', () async {
    when(() => mockFileService.readJsonFromFile(any()))
        .thenAnswer((_) async => <String, dynamic>{'baseLanguage': 'en', 'path': 'expected/path', 'version': '1'});

    when(() => mockFileService.readFilesFromDirectory('expected/path'))
        .thenAnswer((_) async => <Map<String, dynamic>>[]);

    await container.read(projectStateProvider.notifier).loadProjectFileAndTranslations(FakeFile());

    verify(() => mockFileService.readJsonFromFile(any())).called(1);
    verify(() => mockFileService.readFilesFromDirectory(any())).called(1);
  });

  test('Create project state from json list containing 2 languages', () {
    final List<Map<String, dynamic>> input = [
      {
        '@@locale': 'en',
        'themeBlue': 'Blue',
        '@themeBlue': {'description': 'Title of the blue theme'},
        'themeDefault': 'Default',
        '@themeDefault': {'description': 'Title of the default theme'},
        'themeGreen': 'Green',
        '@themeGreen': {'description': 'Title of the green theme'},
      },
      {'@@locale': 'es', 'themeBlue': 'Azul', 'themeDefault': 'Por defecto', 'themeGreen': 'Verde'}
    ];

    // expect to detect base language 'en, as it contains the arb definitions
    final ProjectState expected = ProjectState(
      projectFile: const ProjectFile(baseLanguage: 'en'),
      languageData: LanguageData(
        existingArdbDefinitions: const {
          'themeBlue': ArbDefinition(description: 'Title of the blue theme'),
          'themeDefault': ArbDefinition(description: 'Title of the default theme'),
          'themeGreen': ArbDefinition(description: 'Title of the green theme'),
        },
        existingLanguages: {
          'en': Language(existingTranslations: {'themeBlue': 'Blue', 'themeDefault': 'Default', 'themeGreen': 'Green'}),
          'es': Language(
            existingTranslations: {'themeBlue': 'Azul', 'themeDefault': 'Por defecto', 'themeGreen': 'Verde'},
          )
        },
      ),
    );

    container.read(projectStateProvider.notifier).loadfromJsons(input);
    final ProjectState actual = container.read(projectStateProvider);

    expect(actual, expected);
  });

  test('Adding a new language, creates a new language entry with the already existing translations, but empty', () {
    final List<Map<String, dynamic>> input = [
      {
        '@@locale': 'en',
        'greeting': 'Blue',
        '@greeting': {'description': 'Say hello'},
      },
      {'@@locale': 'de', 'greeting': 'hallo'}
    ];

    container.read(projectStateProvider.notifier).loadfromJsons(input);
    container.read(projectStateProvider.notifier).addLanguage('es');

    final ProjectState projectState = container.read(projectStateProvider);
    expect(projectState.languageData.languages.length, 3);

    final Map<String, String> translations = projectState.languageData.languages['es']!.translations;
    expect(translations.length, 1);
    expect(translations['greeting'], '');
  });

  test('Remove language', () {
    final List<Map<String, dynamic>> input = [
      {
        '@@locale': 'en',
        'greeting': 'Blue',
        '@greeting': {'description': 'Say hello'},
      },
      {'@@locale': 'de', 'greeting': 'hallo'}
    ];

    container.read(projectStateProvider.notifier).loadfromJsons(input);

    container.read(projectStateProvider.notifier).removeLanguage('en');

    final ProjectState projectState = container.read(projectStateProvider);
    expect(projectState.languageData.languages.length, 1);
    expect(projectState.languageData.languages.keys, ['de']);
  });

  test('Adding a translation, adds a new map entry for each language and arb definition', () {
    final List<Map<String, dynamic>> input = [
      {
        '@@locale': 'en',
        'greeting': 'Blue',
        '@greeting': {'description': 'Say hello'},
      },
      {'@@locale': 'de', 'greeting': 'hallo'}
    ];

    container.read(projectStateProvider.notifier).loadfromJsons(input);

    container.read(projectStateProvider.notifier).addTranslation(key: 'food');
    final ProjectState projectState = container.read(projectStateProvider);
    expect(projectState.languageData.languages['en']!.translations.length, 2);
    expect(projectState.languageData.languages['de']!.translations.length, 2);
    expect(projectState.languageData.arbDefinitions.length, 2);

    expect(projectState.languageData.languages['en']!.translations['food'], '');
    expect(projectState.languageData.languages['de']!.translations['food'], '');
    expect(projectState.languageData.arbDefinitions['food'], const ArbDefinition());
  });

  test('Removing a translation, remove the key from translation and arb definition', () {
    final List<Map<String, dynamic>> input = [
      {
        '@@locale': 'en',
        'greeting': 'Blue',
        '@greeting': {'description': 'Say hello'},
      },
      {'@@locale': 'de', 'greeting': 'hallo'}
    ];

    container.read(projectStateProvider.notifier).loadfromJsons(input);

    container.read(projectStateProvider.notifier).removeTranslation('greeting');
    final ProjectState projectState = container.read(projectStateProvider);
    expect(projectState.languageData.languages['en']!.translations.length, 0);
    expect(projectState.languageData.languages['de']!.translations.length, 0);
    expect(projectState.languageData.arbDefinitions.length, 0);
  });

  test('Export every language and its translations to a separate file', () async {
    final List<Map<String, dynamic>> input = [
      {
        '@@locale': 'en',
        'greeting': 'Blue',
        '@greeting': {'description': 'Say hello'},
      },
      {'@@locale': 'de', 'greeting': 'hallo'}
    ];

    container.read(projectStateProvider.notifier).loadfromJsons(input);

    when(() => mockFileService.writeFile(any(), any())).thenAnswer((_) async {});
    await container.read(projectStateProvider.notifier).export('some/path');

    verify(() => mockFileService.writeFile(any(), any())).called(2);
  });
}
