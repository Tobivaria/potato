import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/project/project_state_controller.dart';

class ArbOptionMenu extends ConsumerStatefulWidget {
  const ArbOptionMenu({
    required this.definitionKey,
    required this.arbDefinition,
    Key? key,
  }) : super(key: key);

  final String definitionKey;
  final ArbDefinition arbDefinition;

  @override
  ConsumerState<ArbOptionMenu> createState() => _ArbOptionMenuState();
}

class _ArbOptionMenuState extends ConsumerState<ArbOptionMenu> {
  final FlyoutController _flyoutController = FlyoutController();

  void _addDescription() {
    _flyoutController.close();
    ref
        .read(projectStateProvider.notifier)
        .addDescription(widget.definitionKey);
  }

  void _addPlaceholder() {
    // TODO add placeholder
    _flyoutController.close();
    ref
        .read(projectStateProvider.notifier)
        .addDescription(widget.definitionKey);
  }

  @override
  Widget build(BuildContext context) {
    return Flyout(
      content: (context) {
        return MenuFlyout(
          items: [
            if (widget.arbDefinition.description == null)
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.copy),
                text: const Text('Description'),
                onPressed: _addDescription,
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
      controller: _flyoutController,
      position: FlyoutPosition.below,
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
