import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/language/add_language_dialog.dart';
import 'package:potato/project/project_file_controller.dart';
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

  void _exportData() {
    ref.read(projectStateProvider.notifier).export(ref.read(projectFileProvider).path!);
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
