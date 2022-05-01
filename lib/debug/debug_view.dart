import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/arb/arb_entry.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/language/language.dart';
import 'package:potato/language/language_data.dart';
import 'package:potato/language/language_title.dart';
import 'package:potato/translation/translation_entry.dart';
import 'package:potato/translation/translation_menu.dart';

class DebugView extends ConsumerStatefulWidget {
  const DebugView({Key? key}) : super(key: key);

  @override
  ConsumerState<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends ConsumerState<DebugView> {
  late final LinkedScrollControllerGroup _controllers;
  late final ScrollController _headController;
  late final ScrollController _bodyController;

  late final LinkedScrollControllerGroup _controllers2;
  late final ScrollController _firstColumnController;
  late final ScrollController _restColumnsController;

  late final _scrollController = ScrollController(); // TODO remove
  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();

    _controllers2 = LinkedScrollControllerGroup();
    _firstColumnController = _controllers2.addAndGet();
    _restColumnsController = _controllers2.addAndGet();
  }

  int maxNumber = 10;
  double cellWidth = 50;

  List<String> translations = ['en', 'de'];
  String baseLang = 'en';
  LanguageData languageData = LanguageData(
    existingLanguages: {
      'en': Language(
        existingTranslations: {'a': 'hello', 'b': 'hello 2', 'c': 'hello 3'},
      ),
      'de': Language(
        existingTranslations: {'a': 'hallo', 'b': 'hallo 2', 'c': 'hallo 3'},
      ),
    },
  );

  final Map<String, ArbDefinition> arbDefs = {
    'a': const ArbDefinition(description: 'A Lul'),
    'b': const ArbDefinition(description: 'B Lul'),
    'c': const ArbDefinition(description: 'C Lul')
  };

  List<String> orderedKeys = ['a', 'b', 'c'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TranslationMenu(),
        const Divider(),
        SizedBox(
          height: cellWidth,
          child: Row(
            children: [
              const SizedBox(
                width: Dimensions.idCellWidth,
                child: Text(
                  'Id',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ), // TODO move style to theme
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _headController,
                  child: ListView(
                    controller: _headController,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(translations.length, (index) {
                      return LanguageTitle(
                        translations[index],
                        Dimensions.languageCellWidth,
                        isBaseLanguage: translations[index] == baseLang,
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
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
                    return const Divider();
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _bodyController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: (orderedKeys.length - 1) * Dimensions.idCellWidth,
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
                            for (String languageKey in translations)
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
                        return const Divider();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
