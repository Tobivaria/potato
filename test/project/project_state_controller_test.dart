import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/language/language.dart';
import 'package:potato/language/language_data.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/notification/notification_controller.dart';
import 'package:potato/project/project_file.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/project/project_state_controller.dart';
import 'package:potato/utils/potato_logger.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  late ProviderContainer container;
  late FileService mockFileService;
  late NotificationController mockNotificationController;
  late Logger mockLogger;

  setUpAll(() {
    registerFallbackValue(FakeFile());
    registerFallbackValue(InfoBarSeverity.info);
  });

  setUp(() {
    mockLogger = MockLogger();
    mockFileService = MockFileService();
    mockNotificationController = MockNotificationController();

    container = ProviderContainer(
      overrides: [
        fileServiceProvider.overrideWithValue(mockFileService),
        loggerProvider.overrideWithValue(mockLogger),
        notificationController.overrideWithValue(mockNotificationController)
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
    when(() => mockFileService.writeFile(any(), any()))
        .thenAnswer((_) async {});

    await container
        .read(projectStateProvider.notifier)
        .saveProjectFile('some/path');

    verify(() => mockFileService.writeFile(any(), any())).called(1);
  });

  test('Load project file and all translations', () async {
    when(() => mockFileService.readJsonFromFile(any())).thenAnswer(
      (_) async => <String, dynamic>{
        'baseLanguage': 'en',
        'path': 'expected/path',
        'version': '1'
      },
    );

    when(() => mockFileService.readFilesFromDirectory('expected/path'))
        .thenAnswer((_) async => <Map<String, dynamic>>[]);

    await container
        .read(projectStateProvider.notifier)
        .loadProjectFileAndTranslations(FakeFile());

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
      {
        '@@locale': 'es',
        'themeBlue': 'Azul',
        'themeDefault': 'Por defecto',
        'themeGreen': 'Verde'
      }
    ];

    // expect to detect base language 'en, as it contains the meta definitions
    final ProjectState expected = ProjectState(
      projectFile: const ProjectFile(baseLanguage: 'en'),
      languageData: LanguageData(
        existingArdbDefinitions: const {
          'themeBlue': MetaDefinition(description: 'Title of the blue theme'),
          'themeDefault':
              MetaDefinition(description: 'Title of the default theme'),
          'themeGreen': MetaDefinition(description: 'Title of the green theme'),
        },
        existingLanguages: {
          'en': Language(
            existingTranslations: const {
              'themeBlue': 'Blue',
              'themeDefault': 'Default',
              'themeGreen': 'Green'
            },
          ),
          'es': Language(
            existingTranslations: const {
              'themeBlue': 'Azul',
              'themeDefault': 'Por defecto',
              'themeGreen': 'Verde'
            },
          )
        },
      ),
    );

    container.read(projectStateProvider.notifier).loadfromJsons(input);
    final ProjectState actual = container.read(projectStateProvider);

    expect(actual, expected);
  });

  test(
      'Expect key to not update any, when key already exists / duplicates another',
      () {
    when(() => mockNotificationController.add(any(), any(), any()))
        .thenAnswer((_) async {});

    final List<Map<String, dynamic>> input = [
      {
        '@@locale': 'en',
        'greeting': 'Blue',
        '@greeting': {'description': 'Say hello'},
        'theme': 'Blue',
        '@theme': {'description': 'Say hello'},
      },
      {'@@locale': 'de', 'greeting': 'hallo', 'theme': 'blau'}
    ];

    container.read(projectStateProvider.notifier).loadfromJsons(input);

    // when the key does not exists, trigger a user notification and state does not change
    final ProjectState prev = container.read(projectStateProvider);
    container
        .read(projectStateProvider.notifier)
        .updateKey('greeting', 'theme');
    final ProjectState after = container.read(projectStateProvider);

    verify(() => mockNotificationController.add(any(), any(), any())).called(1);
    expect(prev, after);
  });

  test('Export every language and its translations to a separate file',
      () async {
    final List<Map<String, dynamic>> input = [
      {
        '@@locale': 'en',
        'greeting': 'Blue',
        '@greeting': {'description': 'Say hello'},
      },
      {'@@locale': 'de', 'greeting': 'hallo'}
    ];

    container.read(projectStateProvider.notifier).loadfromJsons(input);

    when(() => mockFileService.writeFile(any(), any()))
        .thenAnswer((_) async {});
    await container.read(projectStateProvider.notifier).export('some/path');

    verify(() => mockFileService.writeFile(any(), any())).called(2);
  });
}
