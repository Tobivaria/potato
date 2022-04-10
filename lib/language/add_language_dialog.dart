import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/language/const_languages.dart';
import 'package:potato/language/language_selectable.dart';
import 'package:potato/project/project_state_controller.dart';

class AddLanguageDialog extends ConsumerStatefulWidget {
  const AddLanguageDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddLanguageDialog> createState() => _AddLanguageState();
}

class _AddLanguageState extends ConsumerState<AddLanguageDialog> {
  final ScrollController _controller = ScrollController();

  final Map<String, Map<String, dynamic>> _languages = Map.from(ConstLanguages.languages);
  late Map<String, Map<String, dynamic>> _filteredLanguages;
  final List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    // remove languages already in the project
    final List<String> existing = ref.read(projectStateProvider).languageData.languages.keys.toList();
    for (final lang in existing) {
      _languages.remove(lang);
    }
    _filteredLanguages = _languages;
  }

  void _languageSelected(String lang) {
    setState(() {
      if (_selected.contains(lang)) {
        _selected.remove(lang);
      } else {
        _selected.add(lang);
      }
    });
  }

  void _addLanguage() {
    for (final lang in _selected) {
      ref.read(projectStateProvider.notifier).addLanguage(lang);
    }
  }

  // apply filter, which matches on the language code and the name of the language
  void _onFilterChange(String val) {
    setState(() {
      _filteredLanguages = Map.from(_languages)
        ..removeWhere((key, value) => !(_compare(key, val) || _compare(value['language'].toString(), val)));
    });
  }

  bool _compare(String valueToCompare, String pattern) {
    return valueToCompare.toLowerCase().contains(pattern.toLowerCase());
  }

  String _formatLanguageText(String key) {
    return '$key - ${_languages[key]!["language"]!}';
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text('Select new languages'),
      content: Column(
        children: [
          TextBox(
            onChanged: _onFilterChange,
            suffix: const Icon(FluentIcons.search),
          ),
          SizedBox(
            height: 400,
            child: ListView.builder(
              controller: _controller,
              itemCount: _filteredLanguages.length,
              itemBuilder: (context, index) {
                final String key = _filteredLanguages.keys.elementAt(index);
                return LanguageSelectable(
                  key: ValueKey(key),
                  text: _formatLanguageText(key),
                  isSelected: _selected.contains(key),
                  selectedCb: () => _languageSelected(key),
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        Button(
          child: const Text('Add'),
          onPressed: () {
            _addLanguage();
            Navigator.pop(context);
          },
        ),
        Button(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
