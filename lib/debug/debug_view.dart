import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/notification/notification_controller.dart';

class DebugView extends ConsumerStatefulWidget {
  const DebugView({Key? key}) : super(key: key);

  @override
  ConsumerState<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends ConsumerState<DebugView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Button(
            onPressed: () =>
                ref.read(notificationNotifier.notifier).add('Some title', 'some msg', InfoBarSeverity.info),
            child: const Text('Show'),
          ),
          Button(
            onPressed: () => ref.read(notificationNotifier.notifier).hideNotification(0),
            child: const Text('Hide'),
          ),
        ],
      ),
    );
  }
}
