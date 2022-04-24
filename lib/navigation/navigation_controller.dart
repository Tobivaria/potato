import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/navigation/navigation_state.dart';
import 'package:potato/navigation/navigation_view_pair.dart';
import 'package:potato/utils/potato_logger.dart';

final Provider routeProvider = Provider<ViewRoute>((ref) {
  return ref.watch(navigationProvider).route;
});

final StateNotifierProvider<NavigationController, NavigationState>
    navigationProvider =
    StateNotifierProvider<NavigationController, NavigationState>((ref) {
  return NavigationController(ref.watch(loggerProvider));
});

class NavigationController extends StateNotifier<NavigationState> {
  NavigationController(this._logger, [NavigationState? init])
      : super(
          init ??
              // default state when launching the app
              const NavigationState(
                route: ViewRoute.home,
              ),
        );

  final Logger _logger;

  void navigateTo(ViewRoute route) {
    _logger.i('Navigating to ${route.name}');
    state = state.copyWith(route: route);
  }
}
