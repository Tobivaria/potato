import 'package:fluent_ui/fluent_ui.dart';

class CreateProject extends StatelessWidget {
  const CreateProject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        FluentIcons.add,
        size: 20,
      ),
      onPressed: () {
        // create project
        // change view to new project
      },
    );
  }
}
