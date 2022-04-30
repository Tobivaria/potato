import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/file_handling/file_picker_service.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/language/add_language_dialog.dart';
import 'package:potato/notification/notification_controller.dart';
import 'package:potato/project/project_state_controller.dart';
import 'package:potato/utils/potato_logger.dart';

class TranslationMenu extends ConsumerStatefulWidget {
  const TranslationMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<TranslationMenu> createState() => _TranslationMenuState();
}

class _TranslationMenuState extends ConsumerState<TranslationMenu> {
  final FlyoutController _flyoutController = FlyoutController();

  @override
  void dispose() {
    _flyoutController.dispose();
    super.dispose();
  }

  Future<void> _importTranslations() async {
    final String? path =
        await _pickLanguageDirectory('Import existing translations');

    // picking aborted
    if (path == null) {
      return;
    }

    final List<Map<String, dynamic>> jsons =
        await ref.read(fileServiceProvider).readFilesFromDirectory(path);

    if (jsons.isEmpty) {
      ref
          .read(notificationController.notifier)
          .add('No data', 'No translations to import', InfoBarSeverity.warning);
      return;
    }

    ref.read(projectStateProvider.notifier).loadfromJsons(jsons);
  }

  Future<String?> _pickLanguageDirectory(String dialogTitle) async {
    final String? path =
        await ref.read(filePickerProvider).pickDirectory(dialogTitle);

    if (path == null) {
      return null;
    }

    ref.read(abosultTranslationPath.notifier).state = path;
    ref.read(loggerProvider).i('Setting absolute translation path: $path');
    return path;
  }

  void _addTranslation() {
    ref.read(projectStateProvider.notifier).addTranslation();
  }

  Future<void> _exportData() async {
    String? path = ref.read(abosultTranslationPath);

    if (path!.isEmpty) {
      path = await _pickLanguageDirectory('Export translations');
    }

    // picking aborted
    if (path == null) {
      return;
    }

    if (ref.read(projectStateProvider).file.baseLanguage == null ||
        ref.read(projectStateProvider).file.baseLanguage!.isEmpty) {
      ref.read(notificationController.notifier).add(
            'Export aborted',
            'Please set a base language first',
            InfoBarSeverity.error,
          );
      return;
    }

    ref.read(projectStateProvider.notifier).export(path);
  }

  @override
  Widget build(BuildContext context) {
    final List<CommandBarButton> _menu = [
      CommandBarButton(
        icon: const Icon(FluentIcons.download),
        label: const Text('Import'),
        onPressed: _importTranslations,
      ),
      CommandBarButton(
        icon: const Icon(FluentIcons.share),
        label: const Text('Export'),
        onPressed: _exportData,
      ),
      CommandBarButton(
        icon: const Icon(FluentIcons.locale_language),
        label: const Text('New language'),
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return const AddLanguageDialog();
          },
        ),
      ),
      CommandBarButton(
        icon: const Icon(FluentIcons.add),
        label: const Text('Add translation'),
        onPressed: _addTranslation,
      ),
    ];

    return SizedBox(
      height: 40,
      child: CommandBar(
        compactBreakpointWidth: 768,
        primaryItems: [..._menu],
      ),
    );
  }
}
