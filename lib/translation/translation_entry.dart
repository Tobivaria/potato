import 'package:fluent_ui/fluent_ui.dart';

class TranslationEntry extends StatefulWidget {
  const TranslationEntry({required this.translation, required this.translationKey, Key? key}) : super(key: key);

  final String? translation;
  final String translationKey;

  @override
  State<TranslationEntry> createState() => _TranslationEntryState();
}

class _TranslationEntryState extends State<TranslationEntry> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.translation ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // TODO put this into a provider
      child: TextBox(
        controller: _controller,
        maxLines: 3,
        placeholder: 'Translation',
        decoration: const BoxDecoration(
          border: Border(),
        ),
        // foregroundDecoration: BoxDecoration(
        //   border: Border(bottom: BorderSide.none),
        // ),
      ),
    );
  }
}
