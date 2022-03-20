import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/navigation/navigation_view_pair.dart';

import '../project/create_project.dart';
import '../project/open_project.dart';
import '../project/save_project.dart';
import 'navigation_controller.dart';

class TopNavigation extends ConsumerWidget {
  const TopNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationProvider);
    return Row(
      children: <Widget>[
        const CreateProject(),
        const OpenProject(
          reduced: true,
        ),
        if (navState.showSaveProject) const SaveProject(),
        if (navState.route == ViewRoute.translations)
          Row(
            children: const [
              SizedBox(
                width: 20,
              ),
              Text('Translations'),
            ],
          ),
      ],
    );
  }
}
