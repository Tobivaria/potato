import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/project/project_state_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    // TODO optimize rebuilds
    final ProjectState projectState = ref.watch(projectStateProvider);
    final List<String> translations =
        projectState.languageData.languages.keys.toList();

    final String? baseLang = projectState.file.baseLanguage;

    return Column(
      children: [
        TranslationMenu(
          disableAddTranslation: translations.isEmpty,
          disableExport: translations.isEmpty,
        ),
        const Divider(),
        if (projectState.languageData.languages.isEmpty)
          const Center(
            child: Text('Start by adding a language'),
          )
        else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TableHeader(
                    languages: translations,
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
