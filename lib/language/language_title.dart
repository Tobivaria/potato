import 'package:fluent_ui/fluent_ui.dart';

class LanguageTitle extends StatelessWidget {
  const LanguageTitle(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // TODO put this into a provider
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold), // TODO move style to theme
      ),
    );
  }
}
