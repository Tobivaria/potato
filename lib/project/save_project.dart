import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/project/project_file_controller.dart';
import 'package:potato/project/project_state_controller.dart';

import '../file_handling/file_picker_service.dart';

class SaveProject extends ConsumerStatefulWidget {
  const SaveProject({Key? key}) : super(key: key);

  @override
  _OpenProjectState createState() => _OpenProjectState();
}

class _OpenProjectState extends ConsumerState<SaveProject> {
  Future<void> _saveProject() async {
    String? path = await ref.read(filePickerProvider).saveFile();
    print(path);

    if (path != null) {
      ref.read(projectFileProvider.notifier).saveProjectFile();
    }
  }

  Future<void> _exportData() async {
    // TODO overwrite dialog
    ref.read(projectStateProvider.notifier).export(ref.read(projectFileProvider).path!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            FluentIcons.save,
          ),
          onPressed: _saveProject,
        ),
        IconButton(
          icon: const Icon(
            FluentIcons.export,
          ),
          onPressed: _exportData,
        ),
      ],
    );
  }
}
