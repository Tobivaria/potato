import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/language/const_languages.dart';
import 'package:potato/language/language_title.dart';

class TableHeader extends ConsumerWidget {
  final List<String> languages;
  final String? baseLanguage;
  final ScrollController scrollController;

  const TableHeader({
    required this.scrollController,
    required this.languages,
    this.baseLanguage,
    Key? key,
  }) : super(key: key);

  String _formatLanguageText(String key) {
    final Map<String, Map<String, dynamic>> _languages =
        Map.from(ConstLanguages.languages);
    return '$key - ${_languages[key]!["language"]!}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: Dimensions.tableHeaderHeight,
      child: Row(
        children: [
          const SizedBox(
            width: Dimensions.idCellWidth,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Id',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ), // TODO move style to theme
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              child: ListView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(languages.length, (index) {
                  return LanguageTitle(
                    languages[index],
                    _formatLanguageText(languages[index]),
                    Dimensions.languageCellWidth,
                    isBaseLanguage: languages[index] == baseLanguage,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
