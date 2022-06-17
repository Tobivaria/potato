import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:potato/core/search_field.dart';
import 'package:potato/language/language.dart';
import 'package:potato/project/project_state_controller.dart';
import 'package:potato/recent_projects/recent_projects.dart';
import 'package:potato/translation/table_body.dart';
import 'package:potato/translation/table_header.dart';
import 'package:potato/translation/translation_menu.dart';

class TranslationView extends ConsumerStatefulWidget {
  const TranslationView({Key? key}) : super(key: key);

  @override
  ConsumerState<TranslationView> createState() => _TranslationViewState();
}

class _TranslationViewState extends ConsumerState<TranslationView> {
  late final LinkedScrollControllerGroup _controllers;
  late final ScrollController _headerController;
  late final ScrollController _bodyController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headerController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  // ignore: use_setters_to_change_properties
  void _onFilterChange(String newValue) {
    ref.read(idFilter.notifier).state = newValue;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Language> languageMap = ref.watch(
      projectStateProvider.select((value) => value.languageData.languages),
    );
    final List<String> languages = languageMap.keys.toList();
    final String? baseLang = ref
        .watch(projectStateProvider.select((value) => value.file.baseLanguage));

    return Column(
      children: [
        TranslationMenu(
          disableAddTranslation: languages.isEmpty,
          disableExport: languages.isEmpty,
        ),
        const Divider(),
        if (languages.isEmpty) ...[
          const Center(
            child: Text(
              'Start by adding a language or import already existing translation files.',
            ),
          ),
          const RecentProjects()
        ] else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchField(
                    placeholder: 'Filter ids',
                    onValueChanged: _onFilterChange,
                  ),
                  TableHeader(
                    languages: languages,
                    baseLanguage: baseLang,
                    scrollController: _headerController,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TableBody(
                    scrollController: _bodyController,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
