import 'package:fluent_ui/fluent_ui.dart';

import '../const/potato_color.dart';

class LanguageSelectable extends StatelessWidget {
  const LanguageSelectable({required this.text, required this.isSelected, required this.selectedCb, Key? key})
      : super(key: key);
  final String text;
  final bool isSelected;
  final VoidCallback selectedCb;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectedCb,
      child: Container(
        height: 30,
        alignment: Alignment.center,
        color: isSelected ? PotatoColor.selected : PotatoColor.background,
        child: Text(text),
      ),
    );
  }
}
