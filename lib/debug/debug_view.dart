import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:potato/settings/shared_preferences_repository.dart';
import 'package:potato/translation_service/deepl/deepl_service.dart';
import 'package:potato/translation_service/translation_config.dart';

class DebugView extends ConsumerStatefulWidget {
  const DebugView({Key? key}) : super(key: key);

  @override
  ConsumerState<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends ConsumerState<DebugView> {
  final TextEditingController _controller = TextEditingController();

  late final DeeplService _deeplService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deeplService = DeeplService(
      client: Client(),
      translationConfig: const TranslationConfig(
        sourceLang: 'EN',
        targetLang: 'DE',
        formality: 'less',
      ),
      preferencesRepository: ref.watch(sharedPreferenceRepositoryProvider),
      name: 'DeepLService',
    );
  }

  String result = '';

  Future<void> _translate() async {
    final String translation = await _deeplService.translate(_controller.text);

    setState(() {
      result = translation;
    });
  }

  Future<void> _usage() async {
    final DeeplUsage? usage = await _deeplService.getUsage();
    print(usage);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      children: [
        Button(
          onPressed: _translate,
          child: const Text('Translate with DeepL'),
        ),
        TextBox(
          controller: _controller,
        ),
        Text(result),
        Button(
          onPressed: _usage,
          child: const Text('Usage'),
        ),
      ],
    );
  }
}
