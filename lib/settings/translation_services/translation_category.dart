import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/settings/settings_category.dart';
import 'package:potato/settings/translation_services/translation_provider.dart';
import 'package:potato/settings/translation_services/translation_services_controller.dart';
import 'package:potato/translation_service/translation_service.dart';

class TranslationCategory extends ConsumerStatefulWidget {
  const TranslationCategory({Key? key}) : super(key: key);

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
            Flyout(
              content: (context) {
                return MenuFlyout(
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
                          _flyoutController.close();
                        },
                      ),
                  ],
                );
              },
              openMode: FlyoutOpenMode.press,
              controller: _flyoutController,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: const Text('Add'),
              ),
            ),
          ],
        ),
        for (var service in translationServices) TranslationProvider(service),
      ],
    );
  }
}
