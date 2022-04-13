import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/notification/potato_notification.dart';

class NotificationPopup extends StatefulWidget {
  const NotificationPopup({
    required this.notification,
    required this.onDismiss,
    Key? key,
  }) : super(key: key);
  final PotatoNotification notification;
  final VoidCallback onDismiss;

  @override
  State<NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup> {
  double _opacity = 1;
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _opacity,
      onEnd: widget.onDismiss,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InfoBar(
          title: Text(widget.notification.title),
          content: Text(widget.notification.message),
          severity: widget.notification.severity,
          onClose: () => setState(() {
            _opacity = 0;
          }),
        ),
      ),
    );
  }
}
