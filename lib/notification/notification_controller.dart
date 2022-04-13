import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/notification/potato_notification.dart';
import 'package:potato/potato_logger.dart';

final Provider<List<PotatoNotification>> notificationProvider = Provider<List<PotatoNotification>>((ref) {
  return ref.watch(notificationNotifier);
});

final StateNotifierProvider<NotificationNotifier, List<PotatoNotification>> notificationNotifier =
    StateNotifierProvider<NotificationNotifier, List<PotatoNotification>>((ref) {
  return NotificationNotifier(ref.watch(loggerProvider));
});

class NotificationNotifier extends StateNotifier<List<PotatoNotification>> {
  NotificationNotifier(this._logger) : super([]);

  final Logger _logger;

  void add(String title, String msg, InfoBarSeverity severity) {
    _logger.i('Adding new notification: $title');
    state = [...state, PotatoNotification(title: title, message: msg, severity: severity, isVisible: true)];
  }

  /// Hide notification by given Id/ position in array
  void hideNotification(int id) {
    _logger.i('Hiding notification: $id - ${state[id].title}');
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == id) state[i].copyWith(isVisible: false) else state[i]
    ];
  }
}
