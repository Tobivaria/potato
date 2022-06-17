import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/settings/translation_services/translation_services_controller.dart';
import 'package:potato/translation_service/translation_config.dart';

class DebugView extends ConsumerStatefulWidget {
  const DebugView({Key? key}) : super(key: key);

  @override
  ConsumerState<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends ConsumerState<DebugView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String result = '';

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(translationServicesProvider).first;
    return ScaffoldPage.scrollable(
      children: [
        Button(
          onPressed: () async {
            final translation = await service.translate(
              _controller.text,
              const TranslationConfig(
                sourceLang: 'EN',
                targetLang: 'DE',
                formality: 'less',
              ),
            );
            setState(() {
              result = translation;
            });
          },
          child: const Text('Translate with DeepL'),
        ),
        TextBox(
          controller: _controller,
        ),
        Text(result),
      ],
    );
  }
}
