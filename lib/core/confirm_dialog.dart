import 'package:fluent_ui/fluent_ui.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    required this.title,
    required this.text,
    required this.confirmButtonText,
    required this.confirmButtonColor,
    required this.onConfirmPressed,
    Key? key,
  }) : super(key: key);

  final String title;
  final String text;
  final String confirmButtonText;
  final Color confirmButtonColor;
  final VoidCallback onConfirmPressed;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmPressed();
          },
          style: ButtonStyle(backgroundColor: ButtonState.all(confirmButtonColor)),
          child: Text(confirmButtonText),
        ),
        Button(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
