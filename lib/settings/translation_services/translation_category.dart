import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/settings/settings_category.dart';
import 'package:potato/settings/translation_services/translation_provider.dart';
import 'package:potato/settings/translation_services/translation_services_controller.dart';
import 'package:potato/translation_service/translation_service.dart';

class TranslationCategory extends ConsumerStatefulWidget {
  const TranslationCategory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TranslationCategoryState();
}

class _TranslationCategoryState extends ConsumerState<TranslationCategory> {
  final FlyoutController _flyoutController = FlyoutController();

  @override
  Widget build(BuildContext context) {
    final List<TranslationService> translationServices =
        ref.watch(translationServicesProvider);

    return Column(
      children: [
        Row(
          children: [
            const SettingsCategory('Translation service'),
            FlyoutTarget(
              controller: _flyoutController,
              child: HyperlinkButton(
                child: const Text('Add'),
                onPressed: () => _flyoutController.showFlyout(
                  builder: (context) => MenuFlyout(
                    items: [
                      if (translationServices.indexWhere(
                            (element) => element.uniqueId() == 'DeepLService',
                          ) ==
                          -1)
                        MenuFlyoutItem(
                          text: const Text('DeepL'),
                          onPressed: () {
                            ref
                                .read(translationServicesProvider.notifier)
                                .addDeepL();
                            Flyout.of(context).close();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        for (var service in translationServices) TranslationProvider(service),
      ],
    );
  }
}
