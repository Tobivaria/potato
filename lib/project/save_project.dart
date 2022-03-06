import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveProject extends ConsumerStatefulWidget {
  const SaveProject({Key? key}) : super(key: key);

  @override
  _OpenProjectState createState() => _OpenProjectState();
}

class _OpenProjectState extends ConsumerState<SaveProject> {
  Future<void> _saveFile() async {
    // ref.read(fileServiceProvider).saveProject(file);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        FluentIcons.save,
        size: 20,
      ),
      onPressed: _saveFile,
    );
  }
}
