import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/meta/meta_number_options.dart';
import 'package:potato/meta/placeholder/meta_placerholder.dart';

enum NumberFormat {
  compact,
  compactCurrency,
  compactSimpleCurrency,
  compactLong,
  currency,
  decimalPattern,
  decimalPercentPattern,
  percentPattern,
  scientificPattern,
  simpleCurrency
}

@immutable
class MetaNumberPlaceholder extends MetaPlaceholder {
  final NumberFormat format;
  late final MetaNumberOptionsBase? options;

  MetaNumberPlaceholder({
    required String id,
    required MetaType type,
    required this.format,
    String? example,
  })  : assert(type == MetaType.DateTime || type == MetaType.String),
        super(id: id, type: type, example: example) {
    switch (format) {
      case NumberFormat.compactCurrency:
        options = const MetaNumberOptionsExtended();
        break;

      case NumberFormat.compactSimpleCurrency:
        options = const MetaNumberOptionsSimple();
        break;

      case NumberFormat.currency:
        options = const MetaNumberOptionsFull();
        break;

      case NumberFormat.decimalPercentPattern:
        options = const MetaNumberOptionsBase();
        break;

      case NumberFormat.simpleCurrency:
        options = const MetaNumberOptionsSimple();
        break;

      default:
        options = null;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> out = super.toMap();
    out['format'] = format.name;
    return out;
  }

  // TODO
  // factory MetaNumberPlaceholder.fromMap(Map<String, dynamic> map) {
  //   final MetaPlaceholder meta = MetaPlaceholder.fromMap(map);
  //   return MetaNumberPlaceholder(
  //     MetaNumberFormat.values.byName(map['format'] as String)
  //   );
  // }

  @override
  String toString() => 'MetaNumberPlaceholder(numberFormat: $format)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MetaNumberPlaceholder && other.format == format;
  }

  @override
  int get hashCode => format.hashCode;
}
