import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/language/language_title.dart';
import 'package:potato/translation/translation_menu.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DebugView extends ConsumerStatefulWidget {
  const DebugView({Key? key}) : super(key: key);

  @override
  ConsumerState<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends ConsumerState<DebugView> {
  final _scrollController = ScrollController();
  final _scrollController2 = ScrollController();

  List<String> translations = ['en', 'de'];
  String baseLang = 'en';

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: NestedScrollView(
        // scrollDirection: Axis.horizontal,
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // const SliverToBoxAdapter(
          //   child: Text('header'),
          // )
        ],
        body: MultiSliver(
          children: [
            SliverFixedExtentList(
              itemExtent: Dimensions.idCellWidth,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text('list item $index'),
                  );
                },
                childCount: 2,
              ),
            ),
          ],
        ),

        // Scrollbar(
        //   controller: _scrollController2,
        //   child: CustomScrollView(
        //     controller: _scrollController2,
        //     scrollDirection: Axis.horizontal,
        //     slivers: [
        //       // SliverToBoxAdapter(
        //       //   child: Column(
        //       //     children: [
        //       //       for (var i = 0; i < 20; i++) ...[
        //       //         const Padding(
        //       //           padding: EdgeInsets.all(20.0),
        //       //           child: Text('data'),
        //       //         ),
        //       //       ],
        //       //     ],
        //       //   ),
        //       // ),
        //       MultiSliver(
        //         children: [
        //           SliverFixedExtentList(
        //             itemExtent: Dimensions.idCellWidth,
        //             delegate: SliverChildBuilderDelegate(
        //               (BuildContext context, int index) {
        //                 return Container(
        //                   alignment: Alignment.center,
        //                   child: Text('list item $index'),
        //                 );
        //               },
        //               childCount: 2,
        //             ),
        //           ),
        //         ],
        //       ),
        //       SliverFixedExtentList(
        //         itemExtent: Dimensions.idCellWidth,
        //         delegate: SliverChildBuilderDelegate(
        //           (BuildContext context, int index) {
        //             return Container(
        //               alignment: Alignment.center,
        //               child: Text('more $index'),
        //             );
        //           },
        //           childCount: 10,
        //         ),
        //       ),
        //     ],
      ),
      // ),
      // ),
    );

    Column(
      children: [
        const TranslationMenu(),
        const Divider(),
        Row(
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
            for (String langKey in translations)
              LanguageTitle(
                langKey,
                Dimensions.languageCellWidth,
                isBaseLanguage: langKey == baseLang,
              )
          ], // TODO put this into a provider
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 250,
                  child: ListView(
                    children: [
                      for (var i = 0; i < 20; i++) ...[
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('data'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}




// alter Ansatz

// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:potato/const/dimensions.dart';
// import 'package:potato/language/language_title.dart';
// import 'package:potato/translation/translation_menu.dart';

// class DebugView extends ConsumerStatefulWidget {
//   const DebugView({Key? key}) : super(key: key);

//   @override
//   ConsumerState<DebugView> createState() => _DebugViewState();
// }

// class _DebugViewState extends ConsumerState<DebugView> {
//   final _scrollController = ScrollController();

//   List<String> translations = ['en', 'de'];
//   String baseLang = 'en';

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const TranslationMenu(),
//         const Divider(),
//         Row(
//           children: [
//             const SizedBox(
//               width: Dimensions.idCellWidth,
//               child: Text(
//                 'Id',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold), // TODO move style to theme
//               ),
//             ),
//             for (String langKey in translations)
//               LanguageTitle(
//                 langKey,
//                 Dimensions.languageCellWidth,
//                 isBaseLanguage: langKey == baseLang,
//               )
//           ], // TODO put this into a provider
//         ),
//         Expanded(
//           child: Scrollbar(
//             controller: _scrollController,
//             child: ListView(
//               controller: _scrollController,
//               scrollDirection: Axis.horizontal,
//               children: [
//                 SizedBox(
//                   width: 250,
//                   child: ListView(
//                     children: [
//                       for (var i = 0; i < 20; i++) ...[
//                         const Padding(
//                           padding: EdgeInsets.all(20.0),
//                           child: Text('data'),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
