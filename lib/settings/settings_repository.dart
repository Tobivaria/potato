import 'package:potato/settings/settings.dart';

abstract class SettingsRepository {
  Future<EmptyTranslation?> getEmptyTranslation();
  Future<void> setEmptyTranslation(EmptyTranslation value);
}
