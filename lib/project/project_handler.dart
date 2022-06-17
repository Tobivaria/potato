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
import 'package:potato/recent_projects/recent_project_controller.dart';
import 'package:potato/utils/potato_logger.dart';

mixin ProjectHandler {
  void showConfirmDialog(WidgetRef ref, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Possible data loss',
        text:
            'All unsaved/ exported data will be lost. Do you want to continue?',
        confirmButtonText: 'Continue',
        confirmButtonColor: PotatoColor.warning,
        onConfirmPressed: () {
          ref.refresh(projectStateProvider);
          ref.refresh(absolutProjectPath);
          ref.refresh(absolutTranslationPath);
        },
      ),
    );
  }

  Future<void> openFile(WidgetRef ref, [String? path]) async {
    File? file;
    if (path == null) {
      file = await ref.read(filePickerProvider).pickFile();
      if (file == null) {
        return;
      }
    } else {
      file = File(path);
    }

    // set abosult project path, which is also used for exporting
    final String absolutePath = file.parent.path;
    ref.read(absolutProjectPath.notifier).state = absolutePath;
    ref.read(loggerProvider).i('Setting abosulte project path: $absolutePath');

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
    ref.read(recentProjectsProvider.notifier).addRecentProject(file.path);
  }

  Future<void> saveProject(WidgetRef ref) async {
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
      ref.read(recentProjectsProvider.notifier).addRecentProject(filePath);
    }
  }
}
