import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugView extends ConsumerStatefulWidget {
  const DebugView({Key? key}) : super(key: key);

  @override
  ConsumerState<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends ConsumerState<DebugView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
