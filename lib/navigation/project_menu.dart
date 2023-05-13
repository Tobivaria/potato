import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/project/project_handler.dart';

class ProjectMenu extends ConsumerStatefulWidget {
  const ProjectMenu({super.key});

  @override
  _ProjectMenuState createState() => _ProjectMenuState();
}

class _ProjectMenuState extends ConsumerState<ProjectMenu> with ProjectHandler {
  final FlyoutController _flyoutController = FlyoutController();

  @override
  void dispose() {
    _flyoutController.dispose();
    super.dispose();
  }

  void _showConfirmDialog(BuildContext context) {
    Flyout.of(context).close();
    showConfirmDialog(ref, context);
  }

  Future<void> _openFile(BuildContext context) async {
    Flyout.of(context).close();
    openFile(ref);
  }

  Future<void> _saveProject(BuildContext context,
      [bool forcePicker = false]) async {
    Flyout.of(context).close();
    saveProject(ref, forcePicker);
  }

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: _flyoutController,
      child: HyperlinkButton(
        child: const Text('Project'),
        onPressed: () => _flyoutController.showFlyout(
          dismissWithEsc: true,
          builder: (context) => MenuFlyout(
            items: [
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.copy),
                text: const Text('New'),
                trailing: const Text('Ctrl + N'),
                onPressed: () => _showConfirmDialog(context),
              ),
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.fabric_open_folder_horizontal),
                text: const Text('Open'),
                trailing: const Text('Ctrl + O'),
                onPressed: () => _openFile(context),
              ),
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.save),
                text: const Text('Save'),
                trailing: const Text('Ctrl + S'),
                onPressed: () => _saveProject(context),
              ),
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.save),
                text: const Text('Save as'),
                onPressed: () => _saveProject(context, true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
