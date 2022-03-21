import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/project/create_project.dart';
import 'package:potato/project/open_project.dart';

class StartView extends StatelessWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CreateProject(reduced: false),
          SizedBox(
            height: 20,
          ),
          OpenProject(reduced: false),
        ],
      ),
    );
  }
}
