import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/potato_logger.dart';
import 'package:potato/project/project_file.dart';
import 'package:potato/project/project_file_controller.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/project/project_state_controller.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  late ProviderContainer container;
  late FileService mockFileService;
  late ProjectStateController mockProjectStateController;
  late Logger mockLogger;

  setUpAll(() {
    registerFallbackValue(FakeFile());
    registerFallbackValue(ProjectState());
  });

  setUp(() {
    mockFileService = MockFileService();
    mockProjectStateController = MockProjectStateController();
    mockLogger = MockLogger();

    container = ProviderContainer(
      overrides: [
        fileServiceProvider.overrideWithValue(mockFileService),
        projectStateProvider.overrideWithValue(mockProjectStateController),
        loggerProvider.overrideWithValue(mockLogger),
      ],
    );

    // setup state
    container.read(projectFileProvider.notifier).setBaseLanguage('en');
    container.read(projectFileProvider.notifier).setPath('some/path');
  });

  tearDown(() {
    container.dispose();
  });

  test('Verify set path and language are working', () {
    final ProjectFile actual = container.read(projectFileProvider);

    expect(actual.baseLanguage, 'en');
    expect(actual.path, 'some/path');
  });

  test('Save project to a file', () async {
    when(() => mockFileService.writeFile(any(), any())).thenAnswer((_) async {});

    await container.read(projectFileProvider.notifier).saveProjectFile();

    verify(() => mockFileService.writeFile(any(), any())).called(1);
  });

  test('Load project file and all translations', () async {
    when(() => mockFileService.readJsonFromFile(any()))
        .thenAnswer((_) async => <String, dynamic>{'baseLanguage': 'en', 'path': 'expected/path', 'version': '1'});

    when(() => mockFileService.readFilesFromDirectory('expected/path'))
        .thenAnswer((_) async => <Map<String, dynamic>>[]);

    await container.read(projectFileProvider.notifier).loadProjectFileAndTranslations(FakeFile());

    verify(() => mockProjectStateController.setProjectState(any())).called(1);
  });
}
