import 'package:fluent_ui/fluent_ui.dart';

class LanguageTitle extends StatelessWidget {
  const LanguageTitle(this.title, this.width, {Key? key}) : super(key: key);

  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold), // TODO move style to theme
      ),
    );
  }
}
