import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/notification/notification_controller.dart';
import 'package:potato/notification/notification_popup.dart';
import 'package:potato/notification/potato_notification.dart';

class NotificationView extends ConsumerStatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends ConsumerState<NotificationView> {
  @override
  Widget build(BuildContext context) {
    final List<PotatoNotification> notifications = ref.watch(notificationProvider);

    return Positioned(
      top: 20,
      right: 20,
      child: Column(
        children: [
          for (int i = 0; i < notifications.length; i++)
            if (notifications[i].isVisible == true)
              NotificationPopup(
                notification: notifications[i],
                onDismiss: () => ref.read(notificationController.notifier).hideNotification(i),
                key: ValueKey(i),
              )
        ],
      ),
    );
  }
}
