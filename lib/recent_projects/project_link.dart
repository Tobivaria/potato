import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: _reset,
      onHover: _hover,
      cursor: SystemMouseCursors.click,
      child: RichText(
        text: TextSpan(
          text: widget.path,
          style: TextStyle(color: Colors.blue, decoration: _textDecoration),
          recognizer: TapGestureRecognizer()..onTap = () => _openFile(),
        ),
      ),
    );
  }
}
