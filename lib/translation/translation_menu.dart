import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/file_handling/file_picker_service.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/language/add_language_dialog.dart';
import 'package:potato/potato_logger.dart';
import 'package:potato/project/project_file_controller.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/project/project_state_controller.dart';

class TranslationMenu extends ConsumerStatefulWidget {
  const TranslationMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<TranslationMenu> createState() => _TranslationMenuState();
}

class _TranslationMenuState extends ConsumerState<TranslationMenu> {
  final flyoutController = FlyoutController();

  @override
  void dispose() {
    flyoutController.dispose();
    super.dispose();
  }

  Future<void> _importTranslations() async {
    final String? path = await _pickLanguageDirectory();

    // picking aborted
    if (path == null) {
      return;
    }

    final List<Map<String, dynamic>> jsons = await ref.read(fileServiceProvider).readFilesFromDirectory(path);

    if (jsons.isEmpty) {
      // TODO show error message
      return;
    }

    ref.read(projectStateProvider.notifier).setProjectState(ProjectState.fromJsons(jsons));
  }

  Future<void> _exportData() async {
    String? path = ref.read(abosultTranslationPath);

    if (path!.isEmpty) {
      path = await _pickLanguageDirectory();
    }

    // picking aborted
    if (path == null) {
      return;
    }

    ref.read(projectStateProvider.notifier).export(path);
  }

  Future<String?> _pickLanguageDirectory() async {
    final String? path = await ref.read(filePickerProvider).pickDirectory();

    if (path == null) {
      return null;
    }

    ref.read(abosultTranslationPath.notifier).state = path;
    ref.read(loggerProvider).i('Setting abosulte translation path: $path');
    return path;
  }

  void _addTranslation() {
    ref.read(projectStateProvider.notifier).addTranslation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO use a real menu, when this is merged and release
    // https://github.com/bdlukaa/fluent_ui/pull/232
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        const Text('Translations'),
        Button(
          onPressed: _importTranslations,
          child: const Text('Import translations'),
        ),
        Button(
          onPressed: _exportData,
          child: const Text('Export'),
        ),
        Button(
          child: const Text('Add language'),
          onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return const AddLanguageDialog();
            },
          ),
        ),
        Button(
          onPressed: _addTranslation,
          child: const Text('Add translation'),
        ),
      ],
    );
  }
}
