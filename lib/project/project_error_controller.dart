import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/utils/potato_logger.dart';

final StateNotifierProvider<ProjectErrorController, Map<String, Set<String>>>
    projectErrorController =
    StateNotifierProvider<ProjectErrorController, Map<String, Set<String>>>((
  StateNotifierProviderRef<ProjectErrorController, Map<String, Set<String>>>
      ref,
) {
  return ProjectErrorController(
    ref.watch(loggerProvider),
  );
});

// TODO test
class ProjectErrorController extends StateNotifier<Map<String, Set<String>>> {
  final Logger logger;

  ProjectErrorController(
    this.logger,
  ) : super({});

  /// Add error (key where the error occurs) to the list of the language
  void addError(String language, String key) {
    logger.d('Adding an error to the list of language: $language for key $key');
    if (state.containsKey(language)) {
      state[language]!.add(key);
    } else {
      state[language] = {key};
    }
    state = state;
  }

  /// Remove error (key where the error was fixed) from the list of the language
  void removeError(String language, String key) {
    logger.d('Removing error of language: $language for key $key');
    state[language]!.remove(key);

    // remove language when there are no errors left
    if (state[language]!.isEmpty) {
      state.remove(language);
    }
    state = state;
  }
}
