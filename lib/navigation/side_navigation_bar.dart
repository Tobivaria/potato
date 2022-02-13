import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/project/open_project.dart';

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
        children: const <Widget>[OpenProject()],
      )),
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
        children: [
          const ScaffoldPage(),
          const ScaffoldPage(),
        ],
      ),
    );
  }
}
