import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:potato/settings/settings_repository.dart';
import 'package:potato/settings/shared_preferences_repository.dart';
import 'package:potato/translation_service/deepl/deepl_service.dart';
import 'package:potato/translation_service/translation_service.dart';
import 'package:potato/utils/potato_logger.dart';

final translationServicesProvider = StateNotifierProvider<
    TranslationServicesController, List<TranslationService>>((
  StateNotifierProviderRef<TranslationServicesController,
          List<TranslationService>>
      ref,
) {
  return TranslationServicesController(
    ref.watch(sharedPreferenceRepositoryProvider),
    ref.watch(loggerProvider),
  );
});

class TranslationServicesController
    extends StateNotifier<List<TranslationService>> {
  final SettingsRepository pref;
  final Logger logger;

  TranslationServicesController(this.pref, this.logger) : super([]) {
    _loadPlatforms();
  }

  Future<void> _loadPlatforms() async {
    final platforms = await pref.getApiPlatforms();
    print(platforms);
    if (platforms == null) return;

    for (final platform in platforms) {
      _restoreService(platform);
    }
  }

  /// Adds services which where persisted earlier
  void _restoreService(String serviceId) {
    // strings need to match the unique identifiers
    switch (serviceId) {
      case 'DeepLService':
        addDeepL();
        break;
      default:
        logger.e('Unknown translation service: $serviceId');
    }
  }

  void addDeepL() {
    final service = DeeplService(
      client: Client(),
      preferencesRepository: pref,
      name: 'DeepL',
    );
    _add(service);
  }

  void _add(TranslationService service) {
    state = [...state, service];
    pref.setApiPlatforms(state.map((e) => e.uniqueId()).toList());
  }

  void remove(TranslationService service) {
    state = state
        .where((element) => element.uniqueId() != service.uniqueId())
        .toList();
  }
}
