import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/const/potato_color.dart';
import 'package:potato/core/confirm_dialog.dart';
import 'package:potato/project/project_state_controller.dart';

class ArbEntry extends ConsumerStatefulWidget {
  const ArbEntry({required this.definition, required this.translationKey, Key? key}) : super(key: key);
  final ArbDefinition definition;
  final String translationKey;

  @override
  ConsumerState<ArbEntry> createState() => _ArbEntryState();
}

class _ArbEntryState extends ConsumerState<ArbEntry> {
  final TextEditingController _translationKeyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _flyoutController = FlyoutController();

  final FocusNode _translationKeyFocusNode = FocusNode();

  bool _showDescription = false;

  double _controlsOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _translationKeyFocusNode.addListener(_updateTranslationKeyState);
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
    _translationKeyController.dispose();
    _descriptionController.dispose();
    _flyoutController.dispose();

    _translationKeyFocusNode.removeListener(_updateTranslationKeyState);
    _translationKeyFocusNode.dispose();

    super.dispose();
  }

  void _initializeFields() {
    _translationKeyController.text = widget.translationKey;
    _descriptionController.text = widget.definition.description ?? '';

    if (widget.definition.description != null) {
      _showDescription = true;
    } else {
      _showDescription = false;
    }
  }

  // update the translation key, once the textfield is losing focus
  void _updateTranslationKeyState() {
    if (!_translationKeyFocusNode.hasFocus) {
      ref.read(projectStateProvider.notifier).updateKey(widget.translationKey, _translationKeyController.text);
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

  void _addEntry() {
    _flyoutController.open = true;
    // TODO make the elements available which are not used
    // TODO add placeholder
    // TODO add description
  }

  void _deleteEntry() {
    ref.read(projectStateProvider.notifier).removeTranslation(_translationKeyController.text);
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
                  controller: _translationKeyController,
                  focusNode: _translationKeyFocusNode,
                  onEditingComplete: () => _translationKeyFocusNode.unfocus(),
                  placeholder: 'Unique key',
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[/\s]')), // prevent whitespaces in the keys
                  ],
                ),
              ),
              if (_showDescription)
                SizedBox(
                  width: Dimensions.languageCellWidth,
                  child: TextBox(
                    controller: _descriptionController,
                    placeholder: 'Description',
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          AnimatedOpacity(
            opacity: _controlsOpacity,
            duration: const Duration(milliseconds: 300),
            child: Column(
              children: [
                Flyout(
                  controller: _flyoutController,
                  verticalOffset: -80,
                  contentWidth: 120, // TODO width
                  content: FlyoutContent(
                    child: SizedBox(
                      height: 50,
                      width: 120, // TODO width
                      child: Column(
                        children: const [Text('Placeholder'), Text('Description')],
                      ),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      FluentIcons.add,
                      size: Dimensions.arbSettingIconSize,
                    ),
                    onPressed: _addEntry,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    FluentIcons.delete,
                    size: Dimensions.arbSettingIconSize,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => ConfirmDialog(
                      title: 'Remove ${_translationKeyController.text}',
                      text: 'This will also remove any translations for this entry. This cannot be undone!',
                      confirmButtonText: 'Delete',
                      confirmButtonColor: PotatoColor.warning,
                      onConfirmPressed: _deleteEntry,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
