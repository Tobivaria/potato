import 'package:fluent_ui/fluent_ui.dart';

@immutable
class PotatoNotification {
  final String title;
  final String message;
  final InfoBarSeverity severity;
  final bool isVisible;

  const PotatoNotification({
    required this.title,
    required this.message,
    required this.severity,
    required this.isVisible,
  });

  PotatoNotification copyWith({
    String? title,
    String? message,
    InfoBarSeverity? severity,
    bool? isVisible,
  }) {
    return PotatoNotification(
      title: title ?? this.title,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PotatoNotification &&
        other.title == title &&
        other.message == message &&
        other.severity == severity &&
        other.isVisible == isVisible;
  }

  @override
  int get hashCode {
    return title.hashCode ^ message.hashCode ^ severity.hashCode ^ isVisible.hashCode;
  }
}
