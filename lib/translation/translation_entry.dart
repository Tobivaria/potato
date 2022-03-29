import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/project/project_state_controller.dart';

class TranslationEntry extends ConsumerStatefulWidget {
  const TranslationEntry({required this.languageKey, required this.translation, required this.translationKey, Key? key})
      : super(key: key);

  final String languageKey;
  final String? translation;
  final String translationKey;

  @override
  ConsumerState<TranslationEntry> createState() => _TranslationEntryState();
}

class _TranslationEntryState extends ConsumerState<TranslationEntry> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.translation ?? '';
    _focus.addListener(_updateTranslation);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.removeListener(_updateTranslation);
    _focus.dispose();

    super.dispose();
  }

  // update the translation key, once the textfield is losing focus
  void _updateTranslation() {
    if (!_focus.hasFocus) {
      ref
          .read(projectStateProvider.notifier)
          .updateTranslation(widget.languageKey, widget.translationKey, _controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // TODO put this into a provider
      child: TextBox(
        controller: _controller,
        focusNode: _focus,
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
