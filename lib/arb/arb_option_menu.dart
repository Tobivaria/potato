import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/const/dimensions.dart';

class ArbOptionMenu extends StatefulWidget {
  const ArbOptionMenu({Key? key}) : super(key: key);

  @override
  State<ArbOptionMenu> createState() => _ArbOptionMenuState();
}

class _ArbOptionMenuState extends State<ArbOptionMenu> {
  final FlyoutController _flyoutController = FlyoutController();

  void _addEntry() {
    // _flyoutController.open();
    // TODO make the elements available which are not used
    // TODO add placeholder
    // TODO add description
  }

  @override
  Widget build(BuildContext context) {
    return Flyout(
      content: (context) {
        return MenuFlyout(
          items: [
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.copy),
              text: const Text('Description'),
              onPressed: () {},
            ),
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.fabric_open_folder_horizontal),
              text: const Text('Placeholder'),
              onPressed: () {},
            ),
          ],
        );
      },
      openMode: FlyoutOpenMode.press,
      verticalOffset: -100,
      controller: _flyoutController,
      child: IconButton(
        icon: const Icon(
          FluentIcons.add,
          size: Dimensions.arbSettingIconSize,
        ),
        onPressed: _flyoutController.open,
      ),
    );
  }
}
