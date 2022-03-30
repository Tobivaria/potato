import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/potato_logger.dart';
import 'package:potato/project/project_file.dart';

/// Abosult path of the potato project file
final StateProvider<String> abosultProjectPath = StateProvider<String>(
  (ref) => '',
);

/// Abosult path of the translation files
final StateProvider<String> abosultTranslationPath = StateProvider<String>(
  (ref) => '',
);

final StateNotifierProvider<ProjectFileController, ProjectFile> projectFileProvider =
    StateNotifierProvider<ProjectFileController, ProjectFile>(
        (StateNotifierProviderRef<ProjectFileController, ProjectFile> ref) {
  return ProjectFileController(
    ref.watch(fileServiceProvider),
    ref.watch(loggerProvider),
  );
});

class ProjectFileController extends StateNotifier<ProjectFile> {
  ProjectFileController(this._fileService, this._logger) : super(const ProjectFile());

  final FileService _fileService;
  final Logger _logger;

  void setPath(String path) {
    _logger.i('Setting translation relative path: $path');
    state = state.copyWith(path: path);
  }

  void setBaseLanguage(String? languageKey) {
    _logger.i('Setting base language: $languageKey');
    state = state.copyWith(baseLanguage: languageKey);
  }

  Future<void> saveProjectFile(String filePath) async {
    _logger.i('Saving project to file');
    _logger.d('$state');

    final Map<String, String> data = state.toMap();
    final File file = File(filePath);
    await _fileService.writeFile(file, data);
  }

  // TODO error handling on loading, return enum
  // TODO absolut and relative pathes
  Future<List<Map<String, dynamic>>?> loadProjectFileAndTranslations(File file) async {
    _logger.i('Loading project');

    final Map<String, dynamic>? data = await _fileService.readJsonFromFile(file);

    if (data == null) {
      _logger.w('Loading project failed ${file.path}');
      return null;
    }

    final ProjectFile project = ProjectFile.fromMap(data);

    // load all arb files and their content
    if (project.path == null || project.path!.isEmpty) {
      _logger.i('Skipping loading translations, as no path was provided');
      return null;
    }

    return _fileService.readFilesFromDirectory(project.path!);
  }
}
