import 'package:http/http.dart';
import 'package:potato/settings/shared_preferences_repository.dart';
import 'package:potato/translation_service/translation_config.dart';
import 'package:potato/translation_service/usage.dart';

abstract class TranslationService {
  final SharedPreferencesRepository preferencesRepository;
  final TranslationConfig translationConfig;
  final Client client;
  final String name;
  int? uuid;

  TranslationService({
    required this.preferencesRepository,
    required this.translationConfig,
    required this.client,
    required this.name,
    this.uuid,
  }) {
    uuid ??= 0; // TODO use uuid package
  }

  String getName() => name;
  Future<String> translate(String toTranslate);
  Future<Usage?> getUsage();

  String get _preferenceKey => '$uuid-ApiKey';

  Future<String> getApiKey() async {
    return await preferencesRepository.getPlatformApiKey(_preferenceKey) ?? '';
  }

  Future<void> setApiKey(String val) {
    return preferencesRepository.setPlatformsApiKey(_preferenceKey, val);
  }
}
