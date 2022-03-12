import 'package:fluent_ui/fluent_ui.dart';

import '../arb/arb_definition.dart';

class ArbEntry extends StatefulWidget {
  const ArbEntry({required this.definition, required this.translationKey, Key? key}) : super(key: key);
  final ArbDefinition definition;
  final String translationKey;

  @override
  State<ArbEntry> createState() => _ArbEntryState();
}

class _ArbEntryState extends State<ArbEntry> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _typeController.text = widget.definition.type?.name ?? '';
    _descriptionController.text = widget.definition.description ?? '';
  }

  @override
  void dispose() {
    _typeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300, // TODO put this into a provider
          child: TextBox(
            controller: _typeController,
            placeholder: 'Type',
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
    );
  }
}
