import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/project/open_project.dart';

import '../project/create_project.dart';
import '../project/save_project.dart';
import '../project/start_view.dart';
import '../translation/translation_view.dart';

// TODO rename widget
class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({Key? key}) : super(key: key);

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        actions: Row(
          children: const <Widget>[
            CreateProject(),
            OpenProject(
              reduced: true,
            ),
            SaveProject()
          ],
        ),
      ),
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        selected: _navIndex,
        onChanged: (newIndex) {
          setState(() {
            _navIndex = newIndex;
          });
        },
        items: [
          PaneItem(icon: const Icon(FluentIcons.desktop_screenshot), title: const Text("Translations")),
        ],
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text("Settings"),
          )
        ],
      ),
      content: NavigationBody(
        index: _navIndex,
        children: const [
          StartView(),
          TranslationView(),
          ScaffoldPage(),
        ],
      ),
    );
  }
}
