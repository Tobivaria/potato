import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/settings/settings.dart';
import 'package:potato/settings/settings_repository.dart';
import 'package:potato/settings/shared_preferences_repository.dart';
import 'package:potato/utils/potato_logger.dart';

final StateNotifierProvider<ProjectSettingsController, Settings>
    settingsControllerProvider =
    StateNotifierProvider<ProjectSettingsController, Settings>((
  StateNotifierProviderRef<ProjectSettingsController, Settings> ref,
) {
  return ProjectSettingsController(
    ref.watch(sharedPreferenceRepositoryProvider),
    ref.watch(loggerProvider),
  );
});

class ProjectSettingsController extends StateNotifier<Settings> {
  final SettingsRepository _repository;
  final Logger logger;

  ProjectSettingsController(
    this._repository,
    this.logger,
  ) : super(const Settings()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final EmptyTranslation? emptyTranslation =
        await _repository.getEmptyTranslation();

    state = state.copyWith(
      emptyTranslation: emptyTranslation,
    );
    logger.i('Settings loaded: ${state.toString()}');
  }

  void setEmptyTranslation(EmptyTranslation val) {
    logger.i('Persisting empty translation: $val');
    state = state.copyWith(emptyTranslation: val);
    _repository.setEmptyTranslation(val);
  }
}
