import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/project/project.dart';
import 'package:potato/translation/arb_entry.dart';
import 'package:potato/translation/translation_entry.dart';

import '../language/add_language_dialog.dart';
import '../language/language_title.dart';
import '../project/project_controller.dart';

class TranslationView extends ConsumerStatefulWidget {
  const TranslationView({Key? key}) : super(key: key);

  @override
  ConsumerState<TranslationView> createState() => _TranslationViewState();
}

class _TranslationViewState extends ConsumerState<TranslationView> {
  void _addLangauge() {
    ref.read(projectProvider.notifier).addLanguage('de');
  }

  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO remove unnecessry stuff here
    final Project project = ref.watch(projectProvider);
    final List<String> translations = ref.watch(languageListProvider);
    final tmp = ref.watch(projectProvider).languages;
    final arbDefs = ref.watch(arbDefinitionProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 0.0), // TODO move to styling const
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Button(
                child: const Text('Add language'),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return const AddLanguageDialog();
                  },
                ),
              ),
              Button(
                  child: const Text('Remove language'),
                  onPressed: () => ref.read(projectProvider.notifier).removeLanguage('de')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [LanguageTitle('Id'), for (var i in translations) LanguageTitle(i)],
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
                String key = tmp[project.baseLanguage]!.translations.keys.elementAt(index);
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
          Button(
              child: Text('Add translation'),
              onPressed: () => ref.read(projectProvider.notifier).addTranslation(key: DateTime.now().toString()))
        ],
      ),
    );
  }
}
