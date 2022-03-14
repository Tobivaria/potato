import 'package:fluent_ui/fluent_ui.dart';

import 'navigation_view_pair.dart';

@immutable
class NavigationState {
  // buttons in top navigation
  final bool showSaveProject;
  final bool showExportTranslations;

  final bool showTranslationButtons;

  final ViewRoute route;

  // buttons in side navigation
  final bool showTranslations;
  const NavigationState({
    required this.showSaveProject,
    required this.showExportTranslations,
    required this.showTranslationButtons,
    required this.route,
    required this.showTranslations,
  });

  NavigationState copyWith({
    bool? showSaveProject,
    bool? showExportTranslations,
    bool? showTranslationButtons,
    ViewRoute? route,
    bool? showTranslations,
  }) {
    return NavigationState(
      showSaveProject: showSaveProject ?? this.showSaveProject,
      showExportTranslations: showExportTranslations ?? this.showExportTranslations,
      showTranslationButtons: showTranslationButtons ?? this.showTranslationButtons,
      route: route ?? this.route,
      showTranslations: showTranslations ?? this.showTranslations,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NavigationState &&
        other.showSaveProject == showSaveProject &&
        other.showExportTranslations == showExportTranslations &&
        other.showTranslationButtons == showTranslationButtons &&
        other.route == route &&
        other.showTranslations == showTranslations;
  }

  @override
  int get hashCode {
    return showSaveProject.hashCode ^
        showExportTranslations.hashCode ^
        showTranslationButtons.hashCode ^
        route.hashCode ^
        showTranslations.hashCode;
  }
}
