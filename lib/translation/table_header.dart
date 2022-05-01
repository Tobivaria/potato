import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50, // TODO add to Dimensions
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
              controller: scrollController,
              child: ListView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(languages.length, (index) {
                  return LanguageTitle(
                    languages[index],
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
