import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/project/project_file_controller.dart';

class CreateProject extends ConsumerStatefulWidget {
  const CreateProject({required this.reduced, Key? key}) : super(key: key);

  final bool reduced; // shows icon or text button

  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends ConsumerState<CreateProject> {
  void _createProject() {
    // TODO ask user for verification before overwriting all data
    ref.refresh(projectFileProvider);
    // Due to the dependency of the project controller, project controller is also resetted. But probably shouldn't
  }

  @override
  Widget build(BuildContext context) {
    return widget.reduced
        ? IconButton(
            icon: const Icon(
              FluentIcons.add,
            ),
            onPressed: _createProject,
          )
        : Button(
            onPressed: _createProject,
            child: const Text('New project...'),
          );
  }
}
