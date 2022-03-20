import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/potato_logger.dart';
import 'package:potato/project/project_file.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/project/project_state_controller.dart';

final StateNotifierProvider<ProjectFileController, ProjectFile> projectFileProvider =
    StateNotifierProvider<ProjectFileController, ProjectFile>(
        (StateNotifierProviderRef<ProjectFileController, ProjectFile> ref) {
  return ProjectFileController(
    ref.watch(projectStateProvider.notifier),
    ref.watch(fileServiceProvider),
    ref.watch(loggerProvider),
  );
});

class ProjectFileController extends StateNotifier<ProjectFile> {
  ProjectFileController(this._projectStateController, this._fileService, this._logger) : super(const ProjectFile());

  final ProjectStateController _projectStateController;
  final FileService _fileService;
  final Logger _logger;

  void setPath(String path) {
    state = state.copyWith(path: path);
  }

  void setBaseLanguage(String languageKey) {
    state = state.copyWith(baseLanguage: languageKey);
  }

  Future<void> saveProjectFile() async {
    _logger.i('Saving project to file');
    _logger.d('$state');

    if (state.path == null) {
      _logger.w('Project file does not have any path yet');
      return;
    }

    final Map<String, String> data = state.toMap();
    final File file = File(state.path!);
    await _fileService.writeFile(file, data);
  }

  // TODO error handling on loading, return enum
  // TODO absolut and relative pathes
  Future<void> loadProjectFileAndTranslations(File file) async {
    _logger.i('Loading project');

    final Map<String, dynamic>? data = await _fileService.readJsonFromFile(file);

    if (data == null) {
      _logger.w('Loading project failed ${file.path}');
      return;
    }

    final ProjectFile project = ProjectFile.fromMap(data);

    // load all arb files and their content
    if (project.path == null) {
      _logger.w('Loading project failed ${file.path}');
      return;
    }

    final List<Map<String, dynamic>> jsons = await _fileService.readFilesFromDirectory(project.path!);
    _projectStateController.setProjectState(ProjectState.fromJsons(jsons));
  }
}
