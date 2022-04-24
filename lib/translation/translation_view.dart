import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/arb/arb_entry.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/language/language_data.dart';
import 'package:potato/language/language_title.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/project/project_state_controller.dart';
import 'package:potato/translation/translation_entry.dart';

class TranslationView extends ConsumerStatefulWidget {
  const TranslationView({Key? key}) : super(key: key);

  @override
  ConsumerState<TranslationView> createState() => _TranslationViewState();
}

class _TranslationViewState extends ConsumerState<TranslationView> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ProjectState projectState = ref.watch(projectStateProvider);
    final List<String> translations =
        projectState.languageData.languages.keys.toList();
    final LanguageData languageData = projectState.languageData;
    final Map<String, ArbDefinition> arbDefs =
        projectState.languageData.arbDefinitions;

    final List<String> orderedKeys = arbDefs.keys.toList()..sort();

    final String? baseLang = projectState.file.baseLanguage;

    return languageData.languages.isEmpty
        ? const Center(
            child: Text('Start by adding a language'),
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(
                12.0, 8.0, 8.0, 0.0), // TODO move to styling const
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: Dimensions.idCellWidth,
                      child: Text(
                        'Id',
                        style: TextStyle(
                            fontWeight:
                                FontWeight.bold), // TODO move style to theme
                      ),
                    ),
                    for (String langKey in translations)
                      LanguageTitle(
                        langKey,
                        Dimensions.languageCellWidth,
                        isBaseLanguage: langKey == baseLang,
                      )
                  ], // TODO put this into a provider
                ),
                const SizedBox(
                  height: 4,
                ),
                // Expanded(
                // child: SingleChildScrollView(
                // shrinkWrap: true,
                // children: [
                // child: Container(
                // height: 36 * translationCount.toDouble() * 2, // TODO entries of translations
                // child: Scrollbar(
                // controller: _controller,
                // child:
                Expanded(
                  child: ListView.separated(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: orderedKeys.length,
                    itemBuilder: (context, index) {
                      final String key = orderedKeys.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ArbEntry(
                              definition: arbDefs[key]!,
                              definitionKey: key,
                            ),
                            for (String languageKey
                                in languageData.languages.keys)
                              TranslationEntry(
                                languageKey: languageKey,
                                translation: languageData.languages[languageKey]
                                    ?.getTranslation(key),
                                translationKey: key,
                                definition: arbDefs[key]!,
                                key: ValueKey('$languageKey-$key'),
                              ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
                ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
  }
}
