import 'package:http/http.dart';
import 'package:potato/settings/settings_repository.dart';
import 'package:potato/translation_service/translation_config.dart';
import 'package:potato/translation_service/usage.dart';

abstract class TranslationService {
  final SettingsRepository preferencesRepository;
  final Client client;
  final String name;

  TranslationService({
    required this.preferencesRepository,
    required this.client,
    required this.name,
  });

  String getName() => name;
  String uniqueId();
  Future<String> translate(String toTranslate, TranslationConfig config);
  Future<Usage?> getUsage();

  String get _preferenceKey => '$uniqueId-ApiKey';

  Future<String> getApiKey() async {
    return await preferencesRepository.getPlatformApiKey(_preferenceKey) ?? '';
  }

  Future<void> setApiKey(String val) {
    return preferencesRepository.setPlatformsApiKey(_preferenceKey, val);
  }
}
