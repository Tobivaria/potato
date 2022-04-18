import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/file_handling/file_picker_service.dart';
import 'package:potato/navigation/navigation_controller.dart';
import 'package:potato/navigation/navigation_view_pair.dart';
import 'package:potato/notification/notification_controller.dart';
import 'package:potato/utils/potato_logger.dart';
import 'package:potato/project/project_state_controller.dart';

/// Widget for opening / loading a previous project
///
/// `reduced` shows an Iconbutton instead
class OpenProject extends ConsumerStatefulWidget {
  const OpenProject({required this.reduced, Key? key}) : super(key: key);

  final bool reduced;

  @override
  _OpenProjectState createState() => _OpenProjectState();
}

class _OpenProjectState extends ConsumerState<OpenProject> {
  Future<void> _openFile() async {
    final File? file = await ref.read(filePickerProvider).pickFile();
    if (file == null) {
      return;
    }

    // set abosult project path, which is also used for exporting
    final String aboslutePath = file.parent.path;
    ref.read(abosultProjectPath.notifier).state = aboslutePath;
    ref.read(loggerProvider).i('Setting abosulte project path: $aboslutePath');

    final List<Map<String, dynamic>>? jsons =
        await ref.read(projectStateProvider.notifier).loadProjectFileAndTranslations(file);

    if (jsons == null) {
      ref.read(notificationController.notifier).add('No data', 'No translations to import', InfoBarSeverity.warning);
      return;
    }

    ref.read(projectStateProvider.notifier).loadfromJsons(jsons);
    ref.read(navigationProvider.notifier).navigateTo(ViewRoute.translations);
  }

  @override
  Widget build(BuildContext context) {
    return widget.reduced
        ? IconButton(
            icon: const Icon(
              FluentIcons.fabric_open_folder_horizontal,
            ),
            onPressed: _openFile,
          )
        : Button(
            onPressed: _openFile,
            child: const Text('Load'),
          );
  }
}
