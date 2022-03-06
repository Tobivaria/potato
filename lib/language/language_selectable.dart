import 'package:fluent_ui/fluent_ui.dart';

import '../const/potato_color.dart';

class LanguageSelectable extends StatefulWidget {
  const LanguageSelectable({required this.text, required this.selectedCb, Key? key}) : super(key: key);
  final String text;
  final VoidCallback selectedCb;

  @override
  State<LanguageSelectable> createState() => _LanguageSelectableState();
}

class _LanguageSelectableState extends State<LanguageSelectable> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.selectedCb();
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Container(
        height: 30,
        alignment: Alignment.center,
        color: _isSelected ? PotatoColor.selected : PotatoColor.background,
        child: Text(widget.text),
      ),
    );
  }
}
