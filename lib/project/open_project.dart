import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/file_handling/file_picker_service.dart';
import 'package:potato/file_handling/file_service.dart';

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
    File? file = await ref.read(filePickerProvider).pickFile();
    if (file == null) {
      return;
    }

    ref.read(fileServiceProvider).loadProject(file);

    // TODO find all files in path...
  }

  @override
  Widget build(BuildContext context) {
    return widget.reduced
        ? IconButton(
            icon: const Icon(
              FluentIcons.fabric_open_folder_horizontal,
              size: 20,
            ),
            onPressed: _openFile,
          )
        : Button(
            child: const Text('Load'),
            // Set onPressed to null to disable the button
            onPressed: _openFile,
          );
  }
}
