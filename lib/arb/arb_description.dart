import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/project/project_state_controller.dart';

class ArbDescription extends ConsumerStatefulWidget {
  const ArbDescription({
    required this.arbKey,
    this.description,
    Key? key,
  }) : super(key: key);

  final String arbKey;
  final String? description;

  @override
  ConsumerState<ArbDescription> createState() => _ArbDescriptionState();
}

class _ArbDescriptionState extends ConsumerState<ArbDescription> {
  final TextEditingController _textontroller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textontroller.text = widget.description ?? '';
    _focusNode.addListener(_updateDescription);
  }

  @override
  void dispose() {
    _textontroller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateDescription() {
    if (_textontroller.text != widget.description) {
      ref
          .read(projectStateProvider.notifier)
          .updateDescription(widget.arbKey, _textontroller.text);
    }
  }

  void _removeDescription() {
    ref.read(projectStateProvider.notifier).removeDescription(widget.arbKey);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            FluentIcons.clear,
            // size: Dimensions.clear, // TODO make smaller
          ),
          onPressed: _removeDescription,
        ),
        SizedBox(
          width: Dimensions.languageCellWidth,
          child: TextBox(
            controller: _textontroller,
            focusNode: _focusNode,
            placeholder: 'Description',
          ),
        ),
      ],
    );
  }
}
