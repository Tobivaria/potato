import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/recent_projects/recent_project_repository.dart';
import 'package:potato/utils/potato_logger.dart';

final StateNotifierProvider<RecentProjectController, List<String>>
    recentProjectsProvider =
    StateNotifierProvider<RecentProjectController, List<String>>(
        (StateNotifierProviderRef<RecentProjectController, List<String>> ref) {
  return RecentProjectController(
    ref.watch(recentProjectsRepositoryProvider),
    ref.watch(loggerProvider),
  );
});

class RecentProjectController extends StateNotifier<List<String>> {
  final RecentProjectRepository _repository;
  final Logger _logger;

  RecentProjectController(
    this._repository,
    this._logger,
  ) : super([]) {
    _loadPrevious();
  }

  Future<void> _loadPrevious() async {
    state = await _repository.getRecentProjects() ?? [];
    _logger.i('Settings loaded: ${state.toString()}');
  }

  Future<void> addRecentProject(String path) async {
    // add newest on top
    // only add up to 10

    _logger.v('Add recent project: $path');

    final projectList = [...state];

    // remove old position in list
    if (projectList.contains(path)) {
      projectList.remove(path);
    }

    projectList.insert(0, path);

    if (projectList.length > 10) {
      projectList.removeLast();
    }

    state = projectList;
    _repository.setRecentProjects(projectList);

    _logger.v('New recent projects: $state');
  }
}
