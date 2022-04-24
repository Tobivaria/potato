import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/arb/arb_description.dart';
import 'package:potato/arb/arb_option_menu.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/const/potato_color.dart';
import 'package:potato/core/confirm_dialog.dart';
import 'package:potato/project/project_state_controller.dart';

class ArbEntry extends ConsumerStatefulWidget {
  const ArbEntry({
    required this.definition,
    required this.definitionKey,
    Key? key,
  }) : super(key: key);
  final ArbDefinition definition;
  final String definitionKey;

  @override
  ConsumerState<ArbEntry> createState() => _ArbEntryState();
}

class _ArbEntryState extends ConsumerState<ArbEntry> {
  final TextEditingController _keyController = TextEditingController();

  final FocusNode _keyFocusNode = FocusNode();

  bool _showDescription = false;
  double _controlsOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _keyFocusNode.addListener(_updateKeyState);
  }

  @override
  void didUpdateWidget(covariant ArbEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      _initializeFields();
    }
  }

  @override
  void dispose() {
    _keyController.dispose();

    _keyFocusNode.removeListener(_updateKeyState);
    _keyFocusNode.dispose();

    super.dispose();
  }

  void _initializeFields() {
    _keyController.text = widget.definitionKey;

    if (widget.definition.description != null) {
      _showDescription = true;
    } else {
      _showDescription = false;
    }
  }

  // update the key, once the textfield is losing focus
  void _updateKeyState() {
    if (!_keyFocusNode.hasFocus &&
        (widget.definitionKey != _keyController.text)) {
      ref
          .read(projectStateProvider.notifier)
          .updateKey(widget.definitionKey, _keyController.text);
    }
  }

  void _enterRegion(PointerEvent details) {
    _toggleControlsOpacity(show: true);
  }

  void _leaveRegion(PointerEvent details) {
    _toggleControlsOpacity(show: false);
  }

  void _toggleControlsOpacity({required bool show}) {
    setState(() {
      _controlsOpacity = show ? 1 : 0;
    });
  }

  void _deleteEntry() {
    ref
        .read(projectStateProvider.notifier)
        .removeTranslation(_keyController.text);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _enterRegion,
      onExit: _leaveRegion,
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: Dimensions.languageCellWidth,
                child: TextBox(
                  controller: _keyController,
                  focusNode: _keyFocusNode,
                  onEditingComplete: () => _keyFocusNode.unfocus(),
                  placeholder: 'Unique key',
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(r'[/\s]'),
                    ), // prevent whitespaces in the keys
                  ],
                ),
              ),
              if (_showDescription)
                ArbDescription(
                  arbKey: widget.definitionKey,
                  description: widget.definition.description,
                ),
            ],
          ),
          const SizedBox(width: 20),
          AnimatedOpacity(
            opacity: _controlsOpacity,
            duration: const Duration(milliseconds: 300),
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(
                    FluentIcons.delete,
                    size: Dimensions.arbSettingIconSize,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => ConfirmDialog(
                      title: 'Remove ${_keyController.text}',
                      text:
                          'This will also remove any translations for this entry. This cannot be undone!',
                      confirmButtonText: 'Delete',
                      confirmButtonColor: PotatoColor.warning,
                      onConfirmPressed: _deleteEntry,
                    ),
                  ),
                ),
                ArbOptionMenu(
                    arbDefinition: widget.definition,
                    definitionKey: widget.definitionKey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
