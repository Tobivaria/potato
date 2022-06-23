import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/const/potato_color.dart';
import 'package:potato/core/confirm_dialog.dart';
import 'package:potato/project/project_error_controller.dart';
import 'package:potato/project/project_state_controller.dart';

class LanguageTitle extends ConsumerStatefulWidget {
  const LanguageTitle(
    this.languageKey,
    this.formattedTitle,
    this.width, {
    this.isBaseLanguage = false,
    Key? key,
  }) : super(key: key);

  final String languageKey;
  final String formattedTitle;
  final double width;
  final bool isBaseLanguage;

  @override
  ConsumerState<LanguageTitle> createState() => _LanguageTitleState();
}

class _LanguageTitleState extends ConsumerState<LanguageTitle> {
  double _controlsOpacity = 0.0;

  void _enterRegion(PointerEvent details) {
    _toggleControlsOpacity(show: true);
  }

  void _leaveRegion(PointerEvent details) {
    _toggleControlsOpacity(show: false);
  }

  void _toggleControlsOpacity({required bool show}) {
    setState(() {
      _controlsOpacity = show ? 1 : 0;
    });
  }

  void _deleteEntry() {
    ref.read(projectStateProvider.notifier).removeLanguage(widget.languageKey);
  }

  void _setBaseLanguage() {
    ref.read(projectStateProvider.notifier).setBaseLanguage(widget.languageKey);
  }

  @override
  Widget build(BuildContext context) {
    final Set<String> languageErrors = ref.watch(errorLanguageListProvider);
    final bool hasError = languageErrors.contains(widget.languageKey);

    return MouseRegion(
      onEnter: _enterRegion,
      onExit: _leaveRegion,
      child: Container(
        width: widget.width,
        color: hasError ? PotatoColor.highlightLanguageError : null,
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.formattedTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ), // TODO move style to theme
                ),
              ),
              const Spacer(),
              if (widget.isBaseLanguage)
                const Tooltip(
                  displayHorizontally: true,
                  message: 'Base language',
                  child: Icon(
                    FluentIcons.favorite_star,
                    size: Dimensions.metaSettingIconSize,
                  ),
                ),
              AnimatedOpacity(
                opacity: _controlsOpacity,
                duration: const Duration(milliseconds: 300),
                child: Row(
                  children: [
                    if (!widget.isBaseLanguage)
                      Tooltip(
                        displayHorizontally: true,
                        message: 'Set as base language',
                        child: IconButton(
                          icon: const Icon(
                            FluentIcons.favorite_star,
                            size: Dimensions.metaSettingIconSize,
                          ),
                          onPressed: _setBaseLanguage,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(
                        FluentIcons.delete,
                        size: Dimensions.metaSettingIconSize,
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => ConfirmDialog(
                          title: 'Remove ${widget.languageKey}',
                          text:
                              'This will also remove any translations for this language. This cannot be undone!',
                          confirmButtonText: 'Delete',
                          confirmButtonColor: PotatoColor.warning,
                          onConfirmPressed: _deleteEntry,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
