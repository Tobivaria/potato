import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/settings/settings.dart';
import 'package:potato/settings/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Provider<SharedPreferencesRepository> sharedPreferenceRepositoryProvider =
    Provider<SharedPreferencesRepository>(
        (ProviderRef<SharedPreferencesRepository> ref) {
  return SharedPreferencesRepository();
});

class SharedPreferencesRepository implements SettingsRepository {
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
  Future<void> setPlatformsApiKey(String id, String val) async {
    _setString(id, val);
  }

  Future<bool?> _getBool(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key);
  }

  Future<int?> _getInt(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key);
  }

  Future<void> _setBool(String key, bool value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
  }

  Future<void> _setInt(String key, int value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  Future<String?> _getString(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  Future<void> _setString(String key, String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  Future<List<String>?> _getStringList(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(key);
  }

  Future<void> _setStringList(String key, List<String> value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList(key, value);
  }
}
