import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/settings/settings.dart';
import 'package:potato/settings/settings_category.dart';
import 'package:potato/settings/settings_controller.dart';
import 'package:potato/settings/translation_services/translation_category.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  void _setEmptyTranslation(EmptyTranslation val) {
    ref.read(settingsControllerProvider.notifier).setEmptyTranslation(val);
  }

  @override
  Widget build(BuildContext context) {
    final Settings settings = ref.watch(settingsControllerProvider);

    final EmptyTranslation emptyTranslation =
        settings.emptyTranslation ?? EmptyTranslation.exportEmpty;

    return ScaffoldPage.scrollable(
      children: [
        const SettingsCategory('Empty translation'),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RadioButton(
            checked: emptyTranslation == EmptyTranslation.exportEmpty,
            onChanged: (value) {
              if (value) {
                _setEmptyTranslation(EmptyTranslation.exportEmpty);
              }
            },
            content: const Text('Export as empty string'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RadioButton(
            checked: emptyTranslation == EmptyTranslation.noExport,
            onChanged: (value) {
              if (value) {
                _setEmptyTranslation(EmptyTranslation.noExport);
              }
            },
            content: const Text("Don't export"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RadioButton(
            checked: emptyTranslation == EmptyTranslation.copyMainLanguage,
            onChanged: (value) {
              if (value) {
                _setEmptyTranslation(EmptyTranslation.copyMainLanguage);
              }
            },
            content: const Text('Copy from main language'),
          ),
        ),
        const TranslationCategory(),
      ],
    );
  }
}
