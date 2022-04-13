import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/const/potato_color.dart';

class PotatoTheme {
  static ThemeData getTheme() {
    return ThemeData(
      accentColor: Colors.blue,
      activeColor: PotatoColor.selected,
      borderInputColor: Colors.green,
      scaffoldBackgroundColor: PotatoColor.background,
    );
  }
}
