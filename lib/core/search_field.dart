import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/const/dimensions.dart';

typedef TextFieldChangedCb = void Function(String foo);

class SearchField extends StatefulWidget {
  final String placeholder;
  final TextFieldChangedCb onValueChanged;
  const SearchField({
    required this.placeholder,
    required this.onValueChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
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
      width: Dimensions.idCellWidth,
      child: TextBox(
        controller: _clearController,
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
