import 'package:potato/settings/settings.dart';

abstract class SettingsRepository {
  Future<EmptyTranslation?> getEmptyTranslation();
  void setEmptyTranslation(EmptyTranslation value);

  // Translation services
  Future<List<String>?> getApiPlatforms();
  Future<void> setApiPlatforms(List<String> val);
  Future<String?> getPlatformApiKey(String key);
  Future<void> setPlatformsApiKey(String key, String val);
}
