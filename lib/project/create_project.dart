import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/navigation/navigation_controller.dart';
import 'package:potato/navigation/navigation_view_pair.dart';

class CreateProject extends ConsumerWidget {
  const CreateProject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(
        FluentIcons.add,
      ),
      onPressed: () => ref.read(navigationProvider.notifier).navigateTo(ViewRoute.settings),
    );
  }
}
