import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/potato_color.dart';
import 'package:potato/settings/usage_statistics.dart';
import 'package:potato/translation_service/translation_service.dart';
import 'package:potato/translation_service/usage.dart';

class TranslationProvider extends ConsumerStatefulWidget {
  final TranslationService service;
  const TranslationProvider(this.service, {Key? key}) : super(key: key);

  @override
  ConsumerState<TranslationProvider> createState() =>
      _TranslationProviderState();
}

class _TranslationProviderState extends ConsumerState<TranslationProvider> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isTestingApi = false;
  Usage? _usage;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_setApiKey);
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getApiKey();
    _getUsage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getApiKey() async {
    final String key = await widget.service.getApiKey();
    _apiKeyController.text = key;
  }

  Future<void> _setApiKey() async {
    // update api key on lost focus and when it changed
    if (!_focus.hasFocus &&
        (await widget.service.getApiKey() != _apiKeyController.text)) {
      widget.service.setApiKey(_apiKeyController.text);
    }
  }

  Future<void> _getUsage() async {
    setState(() {
      _isTestingApi = true;
    });
    final request = await widget.service.getUsage();
    setState(() {
      if (request != null) {
        _usage = request;
        _isTestingApi = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.service.getName(),
          style: FluentTheme.of(context).typography.subtitle,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _isTestingApi
            Expanded(
              child: TextFormBox(
                readOnly: _isTestingApi,
                controller: _apiKeyController,
                placeholder: 'Api key',
                focusNode: _focus,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            if (_isTestingApi)
              const ProgressRing()
            else ...[
              if (_usage == null)
                Icon(
                  FluentIcons.error_badge,
                  color: PotatoColor.errorRed,
                  size: 26,
                )
              else
                Icon(
                  FluentIcons.check_mark,
                  color: PotatoColor.successGreen,
                  size: 26,
                ),
            ],
            const SizedBox(
              width: 8,
            ),

            Button(
              onPressed: _isTestingApi ? null : _getUsage,
              child: const Text('Test'),
            ),
          ],
        ),
        UsageStatistics(_usage)
      ],
    );
  }
}
