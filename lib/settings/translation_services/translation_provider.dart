import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/potato_color.dart';
import 'package:potato/settings/translation_services/usage_statistics.dart';
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
    _focus.removeListener(_setApiKey);
    _focus.dispose();
    super.dispose();
  }

  Future<void> _getApiKey() async {
    final String key = await widget.service.getApiKey();
    _apiKeyController.text = key;
  }

  Future<void> _setApiKey() async {
    // update api key on focus change and the key changed
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

    // check if the widget is still mounted as the request might take longer
    if (mounted) {
      setState(() {
        _isTestingApi = false;
        _usage = request;
      });
    }
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: UsageStatistics(_usage),
            ),
          ],
        ),
      ],
    );
  }
}
