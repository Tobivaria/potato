import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/notification/potato_notification.dart';
import 'package:potato/utils/potato_logger.dart';

final Provider<List<PotatoNotification>> notificationProvider = Provider<List<PotatoNotification>>((ref) {
  return ref.watch(notificationController);
});

final StateNotifierProvider<NotificationController, List<PotatoNotification>> notificationController =
    StateNotifierProvider<NotificationController, List<PotatoNotification>>((ref) {
  return NotificationController(ref.watch(loggerProvider));
});

class NotificationController extends StateNotifier<List<PotatoNotification>> {
  NotificationController(this._logger) : super([]);

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
