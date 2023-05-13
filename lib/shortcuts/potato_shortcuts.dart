import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/core/search_field.dart';
import 'package:potato/navigation/navigation_controller.dart';
import 'package:potato/navigation/navigation_view_pair.dart';
import 'package:potato/project/project_handler.dart';
import 'package:potato/shortcuts/potato_intents.dart';

class PotatoShortcuts extends ConsumerWidget with ProjectHandler {
  final Widget child;
  const PotatoShortcuts({required this.child, super.key});

  /// Focuses the filter, when translation view is active
  void _focusFilter(WidgetRef ref) {
    if (ref.read(routeProvider) == ViewRoute.translations) {
      print('test');
      ref.read(focusFilterNodeProvider).requestFocus();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
            FocusFilter(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
            NewFile(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyO):
            OpenFile(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
            SaveFile(),
      },
      child: Actions(
        actions: {
          FocusFilter: CallbackAction<FocusFilter>(
            onInvoke: (intent) => _focusFilter(ref),
          ),
          NewFile: CallbackAction<NewFile>(
            onInvoke: (intent) => showConfirmDialog(ref, context),
          ),
          OpenFile: CallbackAction<OpenFile>(
            onInvoke: (intent) => openFile(ref),
          ),
          SaveFile: CallbackAction<SaveFile>(
            onInvoke: (intent) => saveProject(ref),
          ),
        },
        child: Focus(
          autofocus: true,
          canRequestFocus: true,
          onFocusChange: (bool changed) => print(changed),
          descendantsAreFocusable: true,
          child: child,
        ),
      ),
    );
  }
}
