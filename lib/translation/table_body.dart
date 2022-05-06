import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/arb/arb_entry.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/language/language_data.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/project/project_state_controller.dart';
import 'package:potato/translation/table_divider.dart';
import 'package:potato/translation/translation_entry.dart';

class TableBody extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const TableBody({required this.scrollController, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TableBodyState();
}

class _TableBodyState extends ConsumerState<TableBody> {
  late final LinkedScrollControllerGroup _controllers;
  late final ScrollController _firstColumnController;
  late final ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO optimize rebuilds
    final ProjectState projectState = ref.watch(projectStateProvider);
    final List<String> languages =
        projectState.languageData.supportedLanguages();
    final LanguageData languageData = projectState.languageData;
    final Map<String, ArbDefinition> arbDefs =
        projectState.languageData.arbDefinitions;

    final List<String> orderedKeys = arbDefs.keys.toList()..sort();

    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: Dimensions.idCellWidth,
            child: ListView.separated(
              controller: _firstColumnController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: orderedKeys.length,
              itemBuilder: (context, index) {
                final String key = orderedKeys.elementAt(index);
                return ArbEntry(
                  definition: arbDefs[key]!,
                  definitionKey: key,
                );
              },
              separatorBuilder: (context, index) {
                return const TableDivider();
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: languages.length * Dimensions.languageCellWidth,
                child: ListView.separated(
                  controller: _restColumnsController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: orderedKeys.length,
                  itemBuilder: (context, index) {
                    final String key = orderedKeys.elementAt(index);
                    return Row(
                      children: [
                        for (String languageKey in languages)
                          TranslationEntry(
                            languageKey: languageKey,
                            translation: languageData.languages[languageKey]
                                ?.getTranslation(key),
                            translationKey: key,
                            definition: arbDefs[key]!,
                            key: ValueKey('$languageKey-$key'),
                          ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const TableDivider();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
