import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/project/project_handler.dart';

class ProjectMenu extends ConsumerStatefulWidget {
  const ProjectMenu({Key? key}) : super(key: key);

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

  void _showConfirmDialog() {
    _flyoutController.close();
    showConfirmDialog(ref, context);
  }

  Future<void> _openFile() async {
    _flyoutController.close();
    openFile(ref);
  }

  Future<void> _saveProject() async {
    _flyoutController.close();
    saveProject(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Flyout(
      content: (context) {
        return MenuFlyout(
          items: [
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.copy),
              text: const Text('New'),
              trailing: const Text('Ctrl + N'),
              onPressed: () => _showConfirmDialog(),
            ),
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.fabric_open_folder_horizontal),
              text: const Text('Open'),
              trailing: const Text('Ctrl + O'),
              onPressed: _openFile,
            ),
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.save),
              text: const Text('Save'),
              trailing: const Text('Ctrl + S'),
              onPressed: _saveProject,
            ),
          ],
        );
      },
      openMode: FlyoutOpenMode.press,
      controller: _flyoutController,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: const Text('Project'),
      ),
    );
  }
}
