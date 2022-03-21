import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/language/language_title.dart';
import 'package:potato/project/project_file_controller.dart';
import 'package:potato/project/project_state.dart';
import 'package:potato/project/project_state_controller.dart';
import 'package:potato/translation/arb_entry.dart';
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
    // TODO remove unnecessry stuff here
    final ProjectState projectState = ref.watch(projectStateProvider);
    final List<String> translations = ref.watch(languageListProvider);
    final tmp = ref.watch(projectStateProvider).languages;
    final arbDefs = ref.watch(arbDefinitionProvider);

    final String? baseLang = ref.watch(projectFileProvider).baseLanguage;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 0.0), // TODO move to styling const
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LanguageTitle('Id', Dimensions.idCellWidth),
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
              itemCount: arbDefs.length,
              itemBuilder: (context, index) {
                final String key = projectState.arbDefinitions.keys.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ArbEntry(
                        definition: arbDefs[key]!,
                        translationKey: key,
                      ),
                      for (var i in tmp.keys)
                        TranslationEntry(
                          translation: tmp[i]?.getTranslation(key),
                          translationKey: key,
                        ),
                      //TranslationEntry() // tmp[project.baseLanaguage]!.translations[key]!
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
