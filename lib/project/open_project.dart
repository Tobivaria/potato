import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/file_handling/file_picker_service.dart';

class OpenProject extends ConsumerStatefulWidget {
  const OpenProject({Key? key}) : super(key: key);

  @override
  _OpenProjectState createState() => _OpenProjectState();
}

class _OpenProjectState extends ConsumerState<OpenProject> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        FluentIcons.fabric_open_folder_horizontal,
        size: 20,
      ),
      onPressed: () => ref.read(filePickerProvider).pickFile(),
    );
  }
}
