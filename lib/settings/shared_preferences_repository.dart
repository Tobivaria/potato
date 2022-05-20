import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/settings/settings.dart';
import 'package:potato/settings/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FutureProvider<SharedPreferences> sharedPreferencesProvider =
    FutureProvider<SharedPreferences>(
  (_) async => SharedPreferences.getInstance(),
);

final Provider<SharedPreferencesRepository> sharedPreferenceRepositoryProvider =
    Provider<SharedPreferencesRepository>(
        (ProviderRef<SharedPreferencesRepository> ref) {
  final pref = ref.watch(sharedPreferencesProvider).maybeWhen(
        data: (value) => value,
        orElse: () => null,
      );
  return SharedPreferencesRepository(pref);
});

class SharedPreferencesRepository implements SettingsRepository {
  final SharedPreferences? preferences;

  SharedPreferencesRepository(this.preferences);

  //##############################
  // Empty translation
  //##############################

  static const String _emptyTranslation = 'emptyTranslation';

  @override
  Future<EmptyTranslation?> getEmptyTranslation() async {
    final String? val = await _getString(_emptyTranslation);

    if (val == null) {
      return null;
    }

    return EmptyTranslation.values.byName(val);
  }

  @override
  Future<void> setEmptyTranslation(EmptyTranslation value) async {
    await _setString(_emptyTranslation, value.name);
  }

  //##############################
  // Platform api keys
  //##############################

  static const String _platforms = 'platforms';

  @override
  Future<List<String>?> getApiPlatforms() async {
    return _getStringList(_platforms);
  }

  @override
  Future<void> setApiPlatforms(List<String> val) async {
    _setStringList(_platforms, val);
  }

  @override
  Future<String?> getPlatformApiKey(String key) async {
    return _getString(key);
  }

  @override
  Future<void> setPlatformsApiKey(String key, String val) async {
    _setString(key, val);
  }

  Future<bool?> _getBool(String key) async {
    return preferences?.getBool(key);
  }

  Future<int?> _getInt(String key) async {
    return preferences?.getInt(key);
  }

  Future<void> _setBool(String key, bool value) async {
    preferences?.setBool(key, value);
  }

  Future<void> _setInt(String key, int value) async {
    preferences?.setInt(key, value);
  }

  Future<String?> _getString(String key) async {
    return preferences?.getString(key);
  }

  Future<void> _setString(String key, String value) async {
    preferences?.setString(key, value);
  }

  Future<List<String>?> _getStringList(String key) async {
    return preferences?.getStringList(key);
  }

  Future<void> _setStringList(String key, List<String> value) async {
    preferences?.setStringList(key, value);
  }
}
