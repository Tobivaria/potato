import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/file_handling/file_picker_service.dart';
import 'package:potato/file_handling/file_service.dart';

class OpenProject extends ConsumerStatefulWidget {
  const OpenProject({Key? key}) : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        FluentIcons.fabric_open_folder_horizontal,
        size: 20,
      ),
      onPressed: _openFile,
    );
  }
}
