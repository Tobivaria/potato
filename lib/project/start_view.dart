import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/project/open_project.dart';

class StartView extends StatelessWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Button(
            child: const Text('New project...'),
            // Set onPressed to null to disable the button
            onPressed: () {
              print('button pressed');
            }),
        const SizedBox(
          height: 20,
        ),
        const OpenProject(reduced: false),
      ]),
    );
  }
}
