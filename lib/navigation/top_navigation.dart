import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/navigation/navigation_controller.dart';
import 'package:potato/navigation/navigation_view_pair.dart';
import 'package:potato/project/create_project.dart';
import 'package:potato/project/open_project.dart';
import 'package:potato/project/save_project.dart';
import 'package:potato/translation/translation_menu.dart';

class TopNavigation extends ConsumerWidget {
  const TopNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationProvider);
    return Row(
      children: <Widget>[
        const CreateProject(
          reduced: true,
        ),
        const OpenProject(
          reduced: true,
        ),
        if (navState.showSaveProject) const SaveProject(),
        const SaveProject(),
        if (navState.route == ViewRoute.translations) const TranslationMenu(),
      ],
    );
  }
}
