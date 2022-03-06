import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/language/language_selectable.dart';

import '../project/project_controller.dart';
import 'const_languages.dart';

class AddLanguageDialog extends ConsumerStatefulWidget {
  const AddLanguageDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddLanguageDialog> createState() => _AddLanguageState();
}

class _AddLanguageState extends ConsumerState<AddLanguageDialog> {
  List<String> languages = [];
  final List<String> selected = [];

  @override
  void initState() {
    super.initState();
    languages = [...ConstLanguages.getLanguageCodes()];
    // remove languages already in the project
    final List<String> existing = ref.read(projectProvider).languages.keys.toList();
    for (var lang in existing) {
      languages.remove(lang);
    }
  }

  void _languageSelected(String lang) {
    if (selected.contains(lang)) {
      selected.remove(lang);
    } else {
      selected.add(lang);
    }
  }

  void _addLanguage() {
    for (var lang in selected) {
      ref.read(projectProvider.notifier).addLanguage(lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Select new languages'),
      content: Column(children: [
        for (var lang in languages)
          LanguageSelectable(
            text: lang,
            selectedCb: () => _languageSelected(lang),
          )
      ]),
      actions: [
        Button(
            child: const Text('Add'),
            onPressed: () {
              _addLanguage();
              Navigator.pop(context);
            }),
        Button(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}
