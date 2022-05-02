import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/const/dimensions.dart';
import 'package:potato/core/entry_state.dart';
import 'package:potato/notification/notification_controller.dart';
import 'package:potato/project/project_error_controller.dart';
import 'package:potato/project/project_state_controller.dart';
import 'package:potato/translation/translation_verification.dart';
import 'package:potato/utils/debounce_timer.dart';
import 'package:potato/utils/potato_logger.dart';

class TranslationEntry extends ConsumerStatefulWidget {
  const TranslationEntry({
    required this.languageKey,
    required this.translation,
    required this.translationKey,
    required this.definition,
    Key? key,
  }) : super(key: key);

  final String languageKey;
  final String? translation;
  final String translationKey;
  final ArbDefinition definition;

  @override
  ConsumerState<TranslationEntry> createState() => _TranslationEntryState();
}

class _TranslationEntryState extends ConsumerState<TranslationEntry> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  EntryState _validtyState = EntryState.valid;
  final DebounceTimer _debounceTimer = DebounceTimer();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.translation ?? '';
    _focus.addListener(_updateTranslation);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.removeListener(_updateTranslation);
    _focus.dispose();
    _debounceTimer.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TranslationEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.definition != widget.definition) {
      // postpone rebuilding after build finished
      WidgetsBinding.instance
          ?.addPostFrameCallback((_) => _validateTranslation());
    }
  }

  // update the translation key, once the textfield is losing focus
  void _updateTranslation() {
    if (!_focus.hasFocus && (widget.translation != _controller.text)) {
      ref.read(projectStateProvider.notifier).updateTranslation(
            widget.languageKey,
            widget.translationKey,
            _controller.text,
          );
      if (_validtyState == EntryState.invalid) {
        _validateTranslation();
        _showStateError();
      }
    }
  }

  void _onTranslationChange(String newValue) {
    _debounceTimer.call(_validateTranslation);
  }

  void _validateTranslation() {
    final TranslationStatus validator =
        TranslationVerification(widget.definition, _controller.text).verify();
    setState(() {
      switch (validator) {
        case TranslationStatus.missingPlaceholder:
          _validtyState = EntryState.invalid;
          ref
              .read(projectErrorController.notifier)
              .addError(widget.languageKey, widget.translationKey);
          break;

        case TranslationStatus.tooMuchPlaceholder:
          _validtyState = EntryState.invalid;
          ref
              .read(projectErrorController.notifier)
              .addError(widget.languageKey, widget.translationKey);
          break;

        case TranslationStatus.placeholderDoesNotExist:
          _validtyState = EntryState.invalid;
          ref
              .read(projectErrorController.notifier)
              .addError(widget.languageKey, widget.translationKey);
          break;

        default:
          // when the background was marked as error previously, mark as correct visually
          if (_validtyState == EntryState.invalid) {
            _validtyState = EntryState.fixed;

            ref.read(projectErrorController.notifier).removeErrorFromLanguage(
                widget.languageKey, widget.translationKey);
          } else {
            _validtyState = EntryState.valid;
          }
      }
    });
  }

  void _showStateError() {
    final TranslationStatus validator =
        TranslationVerification(widget.definition, _controller.text).verify();
    switch (validator) {
      case TranslationStatus.missingPlaceholder:
        ref.read(notificationController.notifier).add(
              'Placeholder missing',
              'Add the placeholder or remove it from definition',
              InfoBarSeverity.warning,
            );
        break;

      case TranslationStatus.tooMuchPlaceholder:
        ref.read(notificationController.notifier).add(
              'Too much placeholder',
              'Decrease the number of placeholder',
              InfoBarSeverity.warning,
            );
        break;

      case TranslationStatus.placeholderDoesNotExist:
        ref.read(notificationController.notifier).add(
              'Placeholder incorrect',
              'The placeholder does not exist in the definition',
              InfoBarSeverity.warning,
            );
        break;

      case TranslationStatus.okay:
        // show nothing
        break;

      default:
        ref
            .read(loggerProvider)
            .wtf('Unimplemented verification status: $validator');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild translation');
    return SizedBox(
      width: Dimensions.languageCellWidth,
      child: Padding(
        padding:
            const EdgeInsets.only(right: Dimensions.languageCellRightPadding),
        child: TextBox(
          controller: _controller,
          focusNode: _focus,
          onChanged: _onTranslationChange,
          maxLines: 3,
          placeholder: 'Translation',
          decoration: const BoxDecoration(
            border: Border(),
          ),
          // foregroundDecoration: BoxDecoration(
          //   border: Border(bottom: BorderSide.none),
          // ),
        ),
      ),
    );
  }
}
