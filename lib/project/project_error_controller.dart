import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/project/project_error.dart';
import 'package:potato/utils/potato_logger.dart';

final Provider<Set<String>> errorLanguageListProvider = Provider<Set<String>>(
  (ref) => ref
      .watch(projectErrorController)
      .map((element) => element.language)
      .toSet(),
);

final StateNotifierProvider<ProjectErrorController, List<ProjectError>>
    projectErrorController =
    StateNotifierProvider<ProjectErrorController, List<ProjectError>>((
  StateNotifierProviderRef<ProjectErrorController, List<ProjectError>> ref,
) {
  return ProjectErrorController(
    ref.watch(loggerProvider),
  );
});

// TODO test
class ProjectErrorController extends StateNotifier<List<ProjectError>> {
  final Logger logger;

  ProjectErrorController(
    this.logger,
  ) : super([]);

  /// Add error (key where the error occurs) to the list of the language
  void addError(String language, String key) {
    logger
        .d('Adding an error to the list for language: $language and key $key');
    state = [...state, ProjectError(language: language, key: key)];
  }

  /// Remove error (key where the error was fixed) from the list of the language
  void removeErrorFromLanguage(String language, String key) {
    logger.d('Removing error of language: $language for key $key');

    state = state
        .where(
          (element) => element.language != language && element.key != key,
        )
        .toList();
  }

  /// Removes all errors for they key. E.g. error was fixed or key was removed
  void removeError(String key) {
    final List<ProjectError> errorList = state
        .where(
          (element) => element.key != key,
        )
        .toList();

    if (state.length != errorList.length) {
      logger.d('Removing any error for key: $key');
      state = errorList;
    }
  }
}
