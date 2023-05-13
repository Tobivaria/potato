import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/project/project_state_controller.dart';

class MetaOptionMenu extends ConsumerStatefulWidget {
  const MetaOptionMenu({
    required this.definitionKey,
    required this.metaDefinition,
    super.key,
  });

  final String definitionKey;
  final MetaDefinition metaDefinition;

  @override
  ConsumerState<MetaOptionMenu> createState() => _MetaOptionMenuState();
}

class _MetaOptionMenuState extends ConsumerState<MetaOptionMenu> {
  final FlyoutController _flyoutController = FlyoutController();

  void _addDescription() {
    Flyout.of(context).close();
    ref
        .read(projectStateProvider.notifier)
        .addDescription(widget.definitionKey);
  }

  void _addPlaceholder() {
    Flyout.of(context).close();
    ref
        .read(projectStateProvider.notifier)
        .addPlaceholder(widget.definitionKey);
  }

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: _flyoutController,
      child: IconButton(
        icon: const Icon(
          FluentIcons.add,
          size: Dimensions.metaSettingIconSize,
        ),
        onPressed: () => _flyoutController.showFlyout(
          builder: (context) => MenuFlyout(
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
          ),
        ),
      ),
    );
  }
}
