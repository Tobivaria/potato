import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/potato_theme.dart';
import 'package:potato/navigation/navigation_manager.dart';
import 'package:potato/shortcuts/potato_shortcuts.dart';

void main() {
  runApp(const PotatoApp());
}

class PotatoApp extends StatelessWidget {
  const PotatoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: FluentApp(
        theme: PotatoTheme.getTheme(),
        home: const PotatoShortcuts(
          child: NavigationManager(),
        ),
      ),
    );
  }
}
