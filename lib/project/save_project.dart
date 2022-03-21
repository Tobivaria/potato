import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/file_handling/file_picker_service.dart';
import 'package:potato/project/project_file_controller.dart';

class SaveProject extends ConsumerStatefulWidget {
  const SaveProject({Key? key}) : super(key: key);

  @override
  _OpenProjectState createState() => _OpenProjectState();
}

class _OpenProjectState extends ConsumerState<SaveProject> {
  Future<void> _saveProject() async {
    final String? path = await ref.read(filePickerProvider).saveFile();

    if (path != null) {
      ref.read(projectFileProvider.notifier).saveProjectFile();
    }
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
      ],
    );
  }
}
