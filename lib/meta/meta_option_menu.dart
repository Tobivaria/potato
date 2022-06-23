import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/project/project_state_controller.dart';

class MetaOptionMenu extends ConsumerStatefulWidget {
  const MetaOptionMenu({
    required this.definitionKey,
    required this.metaDefinition,
    Key? key,
  }) : super(key: key);

  final String definitionKey;
  final MetaDefinition metaDefinition;

  @override
  ConsumerState<MetaOptionMenu> createState() => _MetaOptionMenuState();
}

class _MetaOptionMenuState extends ConsumerState<MetaOptionMenu> {
  final FlyoutController _flyoutController = FlyoutController();

  void _addDescription() {
    _flyoutController.close();
    ref
        .read(projectStateProvider.notifier)
        .addDescription(widget.definitionKey);
  }

  void _addPlaceholder() {
    _flyoutController.close();
    ref
        .read(projectStateProvider.notifier)
        .addPlaceholder(widget.definitionKey);
  }

  @override
  Widget build(BuildContext context) {
    return Flyout(
      content: (context) {
        return MenuFlyout(
          items: [
            if (widget.metaDefinition.description == null)
              MenuFlyoutItem(
                leading: const Icon(FluentIcons.copy),
                text: const Text('Description'),
                onPressed: _addDescription,
              ),
            MenuFlyoutItem(
              leading: const Icon(FluentIcons.fabric_open_folder_horizontal),
              text: const Text('Placeholder'),
              onPressed: _addPlaceholder,
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
          size: Dimensions.metaSettingIconSize,
        ),
        onPressed: _flyoutController.open,
      ),
    );
  }
}
