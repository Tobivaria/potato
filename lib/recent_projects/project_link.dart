import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:potato/project/project_handler.dart';

class ProjectLink extends ConsumerStatefulWidget {
  const ProjectLink({required this.path, Key? key}) : super(key: key);
  final String path;

  @override
  ConsumerState<ProjectLink> createState() => _ProjectLinkState();
}

class _ProjectLinkState extends ConsumerState<ProjectLink> with ProjectHandler {
  TextDecoration? _textDecoration;

  Future<void> _openFile() async {
    openFile(ref, widget.path);
  }

  void _reset(PointerEvent details) {
    setState(() {
      _textDecoration = null;
    });
  }

  void _hover(PointerEvent details) {
    setState(() {
      _textDecoration = TextDecoration.underline;
    });
  }

  String _formatPath() {
    return basename(widget.path).replaceAll('.potato', '');
  }

  String _formatUrl() {
    return widget.path.replaceAll(basename(widget.path), '');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          onExit: _reset,
          onHover: _hover,
          cursor: SystemMouseCursors.click,
          child: RichText(
            text: TextSpan(
              text: _formatPath(),
              style: TextStyle(color: Colors.blue, decoration: _textDecoration),
              recognizer: TapGestureRecognizer()..onTap = () => _openFile(),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(_formatUrl())
      ],
    );
  }
}
