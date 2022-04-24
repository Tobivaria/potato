import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/navigation/navigation_view_pair.dart';

@immutable
class NavigationState {
  final ViewRoute route;

  const NavigationState({
    required this.route,
  });

  NavigationState copyWith({
    ViewRoute? route,
  }) {
    return NavigationState(
      route: route ?? this.route,
    );
  }

  @override
  String toString() => 'NavigationState(route: $route)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NavigationState && other.route == route;
  }

  @override
  int get hashCode => route.hashCode;
}
