import 'package:fluent_ui/fluent_ui.dart';

enum ViewRoute { home, translations, settings }

class NavigationViewPair {
  final NavigationPaneItem navigation;
  final ViewRoute route;
  final Widget view;

  const NavigationViewPair({
    required this.navigation,
    required this.route,
    required this.view,
  });
}
