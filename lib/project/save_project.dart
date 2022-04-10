import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:potato/file_handling/file_picker_service.dart';
import 'package:potato/project/project_state_controller.dart';

class SaveProject extends ConsumerStatefulWidget {
  const SaveProject({Key? key}) : super(key: key);

  @override
  _OpenProjectState createState() => _OpenProjectState();
}

class _OpenProjectState extends ConsumerState<SaveProject> {
  Future<void> _saveProject() async {
    final String? filePath = await ref.read(filePickerProvider).saveFile();

    if (filePath != null) {
      // create relative path as long as it is not set
      if (ref.read(projectStateProvider).file.path == null) {
        if (ref.read(abosultProjectPath).isNotEmpty && ref.read(abosultTranslationPath).isNotEmpty) {
          final String realtiveFilePath = p.relative(
            ref.read(abosultTranslationPath),
            from: ref.read(abosultProjectPath),
          );
          ref.read(projectStateProvider.notifier).setPath(realtiveFilePath);
        }
      }
      ref.read(projectStateProvider.notifier).saveProjectFile(filePath);
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
