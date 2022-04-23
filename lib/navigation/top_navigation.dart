import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/navigation/navigation_controller.dart';
import 'package:potato/navigation/project_menu.dart';

class TopNavigation extends ConsumerWidget {
  const TopNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CommandBarButton> _project = [
      CommandBarButton(
        label: const Text('Project'),
        onPressed: () {},
      ),
      CommandBarButton(
        icon: const Icon(FluentIcons.edit),
        label: const Text('Load'),
        onPressed: () {},
      ),
      CommandBarButton(
        icon: const Icon(FluentIcons.edit),
        label: const Text('Edit'),
        onPressed: () {},
      ),
    ];

    final navState = ref.watch(navigationProvider);

    return
        // CommandBar(
        //   overflowBehavior: CommandBarOverflowBehavior.dynamicOverflow,
        //   compactBreakpointWidth: 768,
        //   primaryItems: [..._project]

        //   Row(
        //     children: <Widget>[
        //       const CreateProject(
        //         reduced: true,
        //       ),
        //       const OpenProject(
        //         reduced: true,
        //       ),
        //       if (navState.showSaveProject) const SaveProject(),
        //       const SaveProject(),
        //       if (navState.route == ViewRoute.translations) const TranslationMenu(),
        //     ],

        // );
        Row(
      children: <Widget>[ProjectMenu()],
    );
  }
}
