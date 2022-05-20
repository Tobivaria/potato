import 'package:fluent_ui/fluent_ui.dart';

class SettingsCategory extends StatelessWidget {
  final String category;
  const SettingsCategory(
    this.category, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      category,
      style: FluentTheme.of(context).typography.title,
    );
  }
}
