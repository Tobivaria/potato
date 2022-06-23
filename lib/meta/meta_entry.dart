import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/const/potato_color.dart';
import 'package:potato/core/confirm_dialog.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/meta/meta_description.dart';
import 'package:potato/meta/meta_option_menu.dart';
import 'package:potato/meta/placeholder/meta_placerholder.dart';
import 'package:potato/meta/placeholder/placeholder_option.dart';
import 'package:potato/project/project_error_controller.dart';
import 'package:potato/project/project_state_controller.dart';
import 'package:potato/settings/translation_services/translation_services_controller.dart';
import 'package:potato/translation_service/translation_config.dart';

class MetaEntry extends ConsumerStatefulWidget {
  const MetaEntry({
    required this.definition,
    required this.definitionKey,
    Key? key,
  }) : super(key: key);
  final MetaDefinition definition;
  final String definitionKey;

  @override
  ConsumerState<MetaEntry> createState() => _MetaEntryState();
}

class _MetaEntryState extends ConsumerState<MetaEntry> {
  final TextEditingController _keyController = TextEditingController();

  final FocusNode _keyFocusNode = FocusNode();

  bool _showDescription = false;
  bool _showPlaceholder = false;
  double _controlsOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _keyFocusNode.addListener(_updateKeyState);
  }

  @override
  void didUpdateWidget(covariant MetaEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      _initializeFields();
    }
  }

  @override
  void dispose() {
    _keyController.dispose();

    _keyFocusNode.removeListener(_updateKeyState);
    _keyFocusNode.dispose();

    super.dispose();
  }

  void _initializeFields() {
    _keyController.text = widget.definitionKey;

    if (widget.definition.description != null) {
      _showDescription = true;
    } else {
      _showDescription = false;
    }

    if (widget.definition.placeholders != null) {
      _showPlaceholder = true;
    } else {
      _showPlaceholder = false;
    }
  }

  // update the key, once the textfield is losing focus
  void _updateKeyState() {
    if (!_keyFocusNode.hasFocus &&
        (widget.definitionKey != _keyController.text)) {
      ref
          .read(projectStateProvider.notifier)
          .updateKey(widget.definitionKey, _keyController.text);
    }
  }

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
    ref.read(projectErrorController.notifier).removeError(_keyController.text);
    ref
        .read(projectStateProvider.notifier)
        .removeTranslation(_keyController.text);
  }

  // translates empty entries
  Future<void> _translate() async {
    final providers = ref.read(translationServicesProvider);
    final baseLang = ref.read(projectStateProvider).file.baseLanguage;

    // TODO pick first for now, later make the user select one if there a more available then one
    if (providers.isEmpty || baseLang == null) {
      return;
    }

    final keyToTranslate = widget.definitionKey;

    final langsMissing = ref
        .read(projectStateProvider.notifier)
        .getEmptyTranslations(keyToTranslate);

    if (langsMissing.isEmpty) {
      return;
    }

    final baseTranslation = ref
        .read(projectStateProvider)
        .languageData
        .languages[baseLang]!
        .translations[keyToTranslate]!;

    final Map<String, String> newTranslations = {};

    for (final lang in langsMissing) {
      final config = TranslationConfig(
        targetLang: lang,
        sourceLang: baseLang,
        formality: 'less',
      );
      final translation =
          await providers.first.translate(baseTranslation, config);
      newTranslations[lang] = translation;
    }

    for (final lang in newTranslations.keys) {
      // TODO create another controller method to bulk change
      ref
          .read(projectStateProvider.notifier)
          .updateTranslation(lang, keyToTranslate, newTranslations[lang]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: Dimensions.tableRowMinHeight,
      ),
      child: MouseRegion(
        onEnter: _enterRegion,
        onExit: _leaveRegion,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  width: Dimensions.idTextfieldWidth,
                  child: TextBox(
                    controller: _keyController,
                    focusNode: _keyFocusNode,
                    onEditingComplete: () => _keyFocusNode.unfocus(),
                    placeholder: 'Unique key',
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(r'[/\s]'),
                      ), // prevent whitespaces in the keys
                    ],
                  ),
                ),
                if (_showDescription)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: Dimensions.paddingBetweenMetaOptions,
                    ),
                    child: MetaDescription(
                      metaKey: widget.definitionKey,
                      description: widget.definition.description,
                    ),
                  ),
                if (_showPlaceholder) ...[
                  for (MetaPlaceholder placeholder
                      in widget.definition.placeholders!)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: Dimensions.paddingBetweenMetaOptions,
                      ),
                      child: PlaceholderOption(
                        metaKey: widget.definitionKey,
                        placeholder: placeholder,
                        key: ValueKey(
                          '${widget.definitionKey}-${placeholder.id}',
                        ),
                      ),
                    ),
                ]
              ],
            ),
            const SizedBox(width: 20),
            AnimatedOpacity(
              opacity: _controlsOpacity,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      FluentIcons.delete,
                      size: Dimensions.metaSettingIconSize,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => ConfirmDialog(
                        title: 'Remove ${_keyController.text}',
                        text:
                            'This will also remove any translations for this entry. This cannot be undone!',
                        confirmButtonText: 'Delete',
                        confirmButtonColor: PotatoColor.warning,
                        onConfirmPressed: _deleteEntry,
                      ),
                    ),
                  ),
                  MetaOptionMenu(
                    metaDefinition: widget.definition,
                    definitionKey: widget.definitionKey,
                  ),
                  Tooltip(
                    message: 'Translate empty values',
                    child: IconButton(
                      icon: const Icon(
                        FluentIcons.translate,
                        size: Dimensions.metaSettingIconSize,
                      ),
                      onPressed: _translate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
