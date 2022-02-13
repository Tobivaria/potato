import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/navigation/side_navigation_bar.dart';

void main() {
  runApp(const PotatoApp());
}

class PotatoApp extends StatelessWidget {
  const PotatoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: FluentApp(
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              accentColor: Colors.blue,
              iconTheme: const IconThemeData(size: 24)),
          darkTheme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              accentColor: Colors.blue,
              iconTheme: const IconThemeData(size: 24)),
          home: const SideNavigationBar()),
    );
  }
}
