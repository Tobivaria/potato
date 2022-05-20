import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:potato/const/potato_color.dart';
import 'package:potato/settings/settings_controller.dart';
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
  bool _isTestingApi = false;
  final TextEditingController _apiKeyController = TextEditingController();
  Usage? _usage;

  @override
  void initState() {
    super.initState();
    _getUsage();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getApiKey();
    _getUsage();
  }

  Future<void> _getApiKey() async {
    // final String key = await ref
    //         .read(sharedPreferenceRepositoryProvider)
    //         .getString(widget.service.preferenceKey) ??
    //     '';
    // _apiKeyController.text = key;
  }

  Future<void> _setApiKey(String newKey) async {
    ref
        .read(settingsControllerProvider.notifier)
        .setApiKey(widget.service.preferenceKey, newKey);
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
    final tmp = ref.watch(settingsControllerProvider).apiKeys;
    print(tmp);
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
                onChanged: _setApiKey,
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
