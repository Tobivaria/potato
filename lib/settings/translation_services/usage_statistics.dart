import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/translation_service/usage.dart';

class UsageStatistics extends StatelessWidget {
  final Usage? usage;
  const UsageStatistics(this.usage, {Key? key}) : super(key: key);

  /// Returns the available percentage, format: 15.2%
  String _percentage() {
    final double percentage = 100 - usage!.usedPercentage;
    return 'Available: ${percentage.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Usage', style: FluentTheme.of(context).typography.bodyLarge),
        if (usage == null)
          const Text('Usage cannot be retrieved.')
        else ...[
          Text(_percentage()),
          Text('${usage!.current.toString()} / ${usage!.max.toString()}'),
        ]
      ],
    );
  }
}
