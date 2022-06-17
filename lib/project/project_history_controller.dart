import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/utils/potato_logger.dart';

final projectStateProvider =
    StateNotifierProvider<ProjectHistoryController, List<ProjectState>>((
  StateNotifierProviderRef<ProjectHistoryController, List<ProjectState>> ref,
) {
  return ProjectHistoryController(
    ref.watch(loggerProvider),
  );
});

class ProjectHistoryController extends StateNotifier<List<ProjectState>> {
  final Logger logger;

  ProjectHistoryController(this.logger) : super([]);

  void addState(ProjectState newState) {
    state = [...state, newState];
  }

  void undo() {}
  void redo() {}
}
