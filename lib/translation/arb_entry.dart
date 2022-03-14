import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/const/potato_color.dart';
import 'package:potato/project/project_controller.dart';

import '../arb/arb_definition.dart';
import '../core/confirm_dialog.dart';

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

  double _controlsOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _translationKeyController.text = widget.translationKey;
    _descriptionController.text = widget.definition.description ?? '';
  }

  @override
  void didUpdateWidget(covariant ArbEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      _translationKeyController.text = widget.translationKey;
      _descriptionController.text = widget.definition.description ?? '';
    }
  }

  @override
  void dispose() {
    _translationKeyController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
    // TODO add placeholder
    // TODO add description
  }

  void _deleteEntry() {
    ref.read(projectProvider.notifier).removeTranslation(_translationKeyController.text);
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
                  placeholder: 'Unique translation key',
                ),
              ),
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
                IconButton(
                  icon: const Icon(
                    FluentIcons.add,
                    size: Dimensions.arbSettingIconSize,
                  ),
                  onPressed: _addEntry,
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
