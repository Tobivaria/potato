import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/arb/arb_placerholder.dart';
import 'package:potato/project/project_state_controller.dart';

class MetaPlaceholder extends ConsumerStatefulWidget {
  final String arbKey;
  final ArbPlaceholder placeholder;

  const MetaPlaceholder({
    required this.arbKey,
    required this.placeholder,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MetaPlaceholder> createState() => _MetaPlaceholderState();
}

class _MetaPlaceholderState extends ConsumerState<MetaPlaceholder> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _exController = TextEditingController();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _exFocus = FocusNode();

  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _idController.text = widget.placeholder.id;
    _exController.text = widget.placeholder.example ?? '';
    _selectedOption = widget.placeholder.type.name;

    _idFocus.addListener(_updateId);
  }

  @override
  void dispose() {
    super.dispose();
    _idController.dispose();
    _exController.dispose();
    _idFocus.dispose();
    _exFocus.dispose();
  }

  void _updateSelection(String newOption) {
    setState(() {
      _selectedOption = newOption;
    });
  }

  // update the id, once the textfield is losing focus
  void _updateId() {
    if (!_idFocus.hasFocus && (widget.placeholder.id != _idController.text)) {
      ref.read(projectStateProvider.notifier).updatePlaceholderID(
            widget.arbKey,
            widget.placeholder.id,
            _idController.text,
          );
    }
  }

  // TODO update selections when implemeneted!
  final List<ArbType> _availableTypes = [ArbType.String];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            DropDownButton(
              title: Text(_selectedOption),
              items: [
                for (ArbType entry in _availableTypes)
                  MenuFlyoutItem(
                    text: Text(entry.name),
                    onPressed: () => _updateSelection(entry.name),
                  ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              width: 200, // TODO move to dimensions
              child: TextBox(
                controller: _idController,
                focusNode: _idFocus,
                placeholder: 'Placeholder id',
                decoration: const BoxDecoration(
                  border: Border(),
                ),
              ),
            ),
            SizedBox(
              width: 200, // TODO move to dimensions
              child: TextBox(
                controller: _exController,
                focusNode: _exFocus,
                placeholder: 'Placeholder example',
                decoration: const BoxDecoration(
                  border: Border(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
