import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/navigation/navigation_state.dart';
import 'package:potato/navigation/navigation_view_pair.dart';

import '../potato_logger.dart';

final Provider routeProvider = Provider<ViewRoute>((ref) {
  return ref.watch(navigationProvider).route;
});

final StateNotifierProvider<NavigationController, NavigationState> navigationProvider =
    StateNotifierProvider<NavigationController, NavigationState>((ref) {
  return NavigationController(ref.watch(loggerProvider));
});

class NavigationController extends StateNotifier<NavigationState> {
  NavigationController(this._logger, [NavigationState? init])
      : super(init ??
            // default state when launching the app
            const NavigationState(
                showExportTranslations: false,
                showSaveProject: false,
                showTranslations: false,
                showTranslationButtons: false,
                route: ViewRoute.translations));

  final Logger _logger;

  void showSaveProject({required bool show}) {
    state = state.copyWith(showSaveProject: show);
  }

  void navigateTo(ViewRoute route) {
    state = state.copyWith(route: route);
  }
}
