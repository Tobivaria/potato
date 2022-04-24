import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/navigation/navigation_controller.dart';
import 'package:potato/navigation/navigation_state.dart';
import 'package:potato/navigation/navigation_view_pair.dart';
import 'package:potato/navigation/project_menu.dart';
import 'package:potato/translation/translation_menu.dart';

class TopNavigation extends ConsumerWidget {
  const TopNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NavigationState navState = ref.watch(navigationProvider);

    return navState.route == ViewRoute.home
        ? const ProjectMenu()
        : const TranslationMenu();
  }
}
