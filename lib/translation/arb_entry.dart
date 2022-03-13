import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/project/project_controller.dart';

import '../arb/arb_definition.dart';

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            SizedBox(
              width: 300, // TODO put this into a provider
              child: TextBox(
                controller: _translationKeyController,
                placeholder: 'Unique translation key',
              ),
            ),
            SizedBox(
              width: 300, // TODO put this into a provider
              child: TextBox(
                controller: _descriptionController,
                placeholder: 'Description',
              ),
            ),
          ],
        ),
        Column(
          children: [
            IconButton(
              icon: const Icon(
                FluentIcons.delete,
                size: Dimensions.arbSettingIconSize,
              ),
              onPressed: () => ref.read(projectProvider.notifier).removeTranslation(_translationKeyController.text),
            )
          ],
        )
      ],
    );
  }
}
