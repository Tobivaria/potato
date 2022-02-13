import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenProject extends ConsumerStatefulWidget {
  const OpenProject({Key? key}) : super(key: key);

  @override
  _OpenProjectState createState() => _OpenProjectState();
}

class _OpenProjectState extends ConsumerState<OpenProject> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        FluentIcons.fabric_open_folder_horizontal,
        size: 20,
      ),
      onPressed: () => print('Open'),
    );
  }
}
