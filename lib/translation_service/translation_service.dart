import 'package:http/http.dart';
import 'package:potato/settings/shared_preferences_repository.dart';
import 'package:potato/translation_service/fake_service.dart';
import 'package:potato/translation_service/translation_config.dart';
import 'package:potato/translation_service/usage.dart';

abstract class TranslationService {
  final SharedPreferencesRepository preferencesRepository;
  final FakeConfig fakeConfig; // TODO pour into abstract class
  final TranslationConfig translationConfig;
  final Client client;

  TranslationService({
    required this.preferencesRepository,
    required this.fakeConfig,
    required this.translationConfig,
    required this.client,
  });

  String getName();
  Future<String> translate(String toTranslate);
  Future<Usage?> getUsage();

  String get preferenceKey => '${getName()}ApiKey';
}
