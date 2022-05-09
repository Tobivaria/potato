import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:potato/const/potato_color.dart';
import 'package:potato/core/confirm_dialog.dart';
import 'package:potato/file_handling/file_picker_service.dart';
import 'package:potato/navigation/navigation_controller.dart';
import 'package:potato/navigation/navigation_view_pair.dart';
import 'package:potato/notification/notification_controller.dart';
import 'package:potato/project/project_state_controller.dart';
import 'package:potato/utils/potato_logger.dart';

class ProjectMenu extends ConsumerStatefulWidget {
  const ProjectMenu({Key? key}) : super(key: key);

  @override
  _ProjectMenuState createState() => _ProjectMenuState();
}

class _ProjectMenuState extends ConsumerState<ProjectMenu> {
  final FlyoutController _flyoutController = FlyoutController();

  @override
  void dispose() {
    _flyoutController.dispose();
    super.dispose();
  }

  void _showConfirmDialog() {
    _flyoutController.close();
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Possible data loss',
        text:
            'All unsaved/ exported data will be lost. Do you want to continue?',
        confirmButtonText: 'Continue',
        confirmButtonColor: PotatoColor.warning,
        onConfirmPressed: _createProject,
      ),
    );
  }

  void _createProject() {
    ref.refresh(projectStateProvider);
    ref.refresh(absolutProjectPath);
    ref.refresh(absolutTranslationPath);
  }

  Future<void> _openFile() async {
    _flyoutController.close();
    final File? file = await ref.read(filePickerProvider).pickFile();
    if (file == null) {
      return;
    }

    // set abosult project path, which is also used for exporting
    final String aboslutePath = file.parent.path;
    ref.read(absolutProjectPath.notifier).state = aboslutePath;
    ref.read(loggerProvider).i('Setting abosulte project path: $aboslutePath');

    final List<Map<String, dynamic>>? jsons = await ref
        .read(projectStateProvider.notifier)
        .loadProjectFileAndTranslations(file);

    if (jsons == null) {
      ref
          .read(notificationController.notifier)
          .add('No data', 'No translations to import', InfoBarSeverity.warning);
      return;
    }

    ref.read(projectStateProvider.notifier).loadfromJsons(jsons);
    ref.read(navigationProvider.notifier).navigateTo(ViewRoute.translations);
  }

  Future<void> _saveProject() async {
    _flyoutController.close();
    final String? filePath = await ref.read(filePickerProvider).saveFile();

    if (filePath != null) {
      // create relative path as long as it is not set
      if (ref.read(projectStateProvider).file.path == null) {
        if (ref.read(absolutProjectPath).isNotEmpty &&
            ref.read(absolutTranslationPath).isNotEmpty) {
          final String realtiveFilePath = p.relative(
            ref.read(absolutTranslationPath),
            from: ref.read(absolutProjectPath),
          );
          ref.read(projectStateProvider.notifier).setPath(realtiveFilePath);
        }
      }
      ref.read(projectStateProvider.notifier).saveProjectFile(filePath);
    }
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
              onPressed: _showConfirmDialog,
            ),
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.fabric_open_folder_horizontal),
              text: const Text('Open'),
              onPressed: _openFile,
            ),
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.save),
              text: const Text('Save'),
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
