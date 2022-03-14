import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/navigation/navigation_controller.dart';
import 'package:potato/navigation/top_navigation.dart';

import '../project/start_view.dart';
import '../translation/translation_view.dart';
import 'navigation_view_pair.dart';

class NavigationManager extends ConsumerStatefulWidget {
  const NavigationManager({Key? key}) : super(key: key);

  @override
  ConsumerState<NavigationManager> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends ConsumerState<NavigationManager> {
  final List<NavigationViewPair> _navigationViewPairs = [
    NavigationViewPair(
      navigation: PaneItem(
        icon: const Icon(FluentIcons.desktop_screenshot),
        title: const Text("Translations"),
      ),
      route: ViewRoute.translations,
      view: const StartView(),
    ),
    NavigationViewPair(
      navigation: PaneItem(
        icon: const Icon(FluentIcons.settings),
        title: const Text("Settings"),
      ),
      route: ViewRoute.settings,
      view: const TranslationView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final route = ref.watch(routeProvider);
    final int navIndex = _navigationViewPairs.indexWhere((e) => e.route == route);

    return NavigationView(
      appBar: const NavigationAppBar(
        actions: TopNavigation(),
      ),
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        size: const NavigationPaneSize(
          openWidth: 150,
        ),
        selected: navIndex,
        onChanged: (newIndex) => ref.read(navigationProvider.notifier).navigateTo(_navigationViewPairs[newIndex].route),
        items: _navigationViewPairs.getRange(0, _navigationViewPairs.length - 1).map((e) => e.navigation).toList(),
        footerItems: [_navigationViewPairs.last.navigation],
      ),
      content: NavigationBody(index: navIndex, children: _navigationViewPairs.map((e) => e.view).toList()),
    );
  }
}
