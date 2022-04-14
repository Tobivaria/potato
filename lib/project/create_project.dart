import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/potato_color.dart';
import 'package:potato/core/confirm_dialog.dart';
import 'package:potato/project/project_state_controller.dart';

class CreateProject extends ConsumerStatefulWidget {
  const CreateProject({required this.reduced, Key? key}) : super(key: key);

  final bool reduced; // shows icon or text button

  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends ConsumerState<CreateProject> {
  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Possible data loss',
        text: 'All unsaved/ exported data will be lost. Do you want to continue?',
        confirmButtonText: 'Continue',
        confirmButtonColor: PotatoColor.warning,
        onConfirmPressed: _createProject,
      ),
    );
  }

  void _createProject() {
    ref.refresh(projectStateProvider);
    ref.refresh(abosultProjectPath);
    ref.refresh(abosultTranslationPath);
  }

  @override
  Widget build(BuildContext context) {
    return widget.reduced
        ? IconButton(
            icon: const Icon(
              FluentIcons.add,
            ),
            onPressed: _showConfirmDialog,
          )
        : Button(
            onPressed: _showConfirmDialog,
            child: const Text('New project...'),
          );
  }
}
