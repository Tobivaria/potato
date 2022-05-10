import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/dimensions.dart';

/// Absolut path of the potato project file
final AutoDisposeStateProvider<FocusNode> focusFilterNodeProvider =
    StateProvider.autoDispose<FocusNode>(
  (ref) => FocusNode(),
);

typedef TextFieldChangedCb = void Function(String foo);

class SearchField extends ConsumerStatefulWidget {
  final String placeholder;
  final TextFieldChangedCb onValueChanged;
  const SearchField({
    required this.placeholder,
    required this.onValueChanged,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  final TextEditingController _clearController = TextEditingController();
  bool _showFilterClear = false;

  @override
  void dispose() {
    _clearController.dispose();
    super.dispose();
  }

  // ignore: use_setters_to_change_properties
  void _onFilterChange(String newValue) {
    if (newValue.isEmpty) {
      setState(() {
        _showFilterClear = false;
      });
    } else {
      if (!_showFilterClear) {
        setState(() {
          _showFilterClear = true;
        });
      }
    }
    widget.onValueChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.idTextfieldWidth,
      child: TextBox(
        controller: _clearController,
        focusNode: ref.watch(focusFilterNodeProvider),
        onChanged: _onFilterChange,
        placeholder: widget.placeholder,
        suffix: _showFilterClear
            ? IconButton(
                icon: const Icon(FluentIcons.chrome_close),
                onPressed: () {
                  _clearController.clear();
                  _onFilterChange('');
                },
              )
            : null,
      ),
    );
  }
}
