import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/settings/settings.dart';
import 'package:potato/settings/settings_repository.dart';
import 'package:potato/settings/shared_preferences_repository.dart';
import 'package:potato/utils/potato_logger.dart';

final StateNotifierProvider<ProjectErrorController, Settings>
    settingsControllerProvider =
    StateNotifierProvider<ProjectErrorController, Settings>((
  StateNotifierProviderRef<ProjectErrorController, Settings> ref,
) {
  return ProjectErrorController(
    ref.watch(sharedPreferenceRepositoryProvider),
    ref.watch(loggerProvider),
  );
});

class ProjectErrorController extends StateNotifier<Settings> {
  final SettingsRepository _repository;
  final Logger logger;

  ProjectErrorController(
    this._repository,
    this.logger,
  ) : super(const Settings()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final EmptyTranslation? emptyTranslation =
        await _repository.getEmptyTranslation();
    final List<String>? platforms = await _repository.getApiPlatforms();

    final Map<String, String>? platformKeys =
        await _createPlatformApiMap(platforms);

    state = state.copyWith(
      emptyTranslation: emptyTranslation,
      apiKeys: platformKeys,
    );
    logger.i('Settings loaded: ${state.toString()}');
  }

  void setEmptyTranslation(EmptyTranslation val) {
    logger.i('Persisting empty translation: $val');
    state = state.copyWith(emptyTranslation: val);
    _repository.setEmptyTranslation(val);
  }

  Future<void> setApiKey(String platform, String key) async {
    logger.i('Persisting $platform key: $key');

    // persist plattform if not already available
    if (state.apiKeys?.containsKey(platform) == false) {
      _repository.setApiPlatforms(state.apiKeys!.keys.toList());
      _repository.setPlatformsApiKey(platform, key);
      state = state.copyWith(
        apiKeys: {...?state.apiKeys, platform: key},
      );
      return;
    }

    // platform already exists
    _repository.setPlatformsApiKey(platform, key);
    final Map<String, String> platformCopy = {...?state.apiKeys};
    platformCopy[platform] = key;

    state = state.copyWith(
      apiKeys: platformCopy,
    );
  }

  Future<Map<String, String>?> _createPlatformApiMap(
    List<String>? platforms,
  ) async {
    if (platforms == null) {
      return null;
    }
    final Map<String, String> platformKeys = {};
    for (final platform in platforms) {
      final String key = await _repository.getPlatformApiKey(platform) ?? '';
      platformKeys[platform] = key;
    }
    return platformKeys;
  }
}
