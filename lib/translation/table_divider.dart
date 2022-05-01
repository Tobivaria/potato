import 'package:fluent_ui/fluent_ui.dart';

class TableDivider extends StatelessWidget {
  const TableDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(color: Colors.grey, height: 1), // TODO change color
    );
  }
}
