import 'package:fluent_ui/fluent_ui.dart';

enum NumberOptions {
  decimalDigits,
  name,
  symbol,
  pattern,
}

abstract class MetaNumberOptions {
  List<NumberOptions> getOptions();
  // Map<String, dynamic> getValues;
}

class MetaNumberOptionsBaseNew implements MetaNumberOptions {
  final List<NumberOptions> _options = [NumberOptions.decimalDigits];
  @override
  List<NumberOptions> getOptions() {
    return _options;
  }

  // factory MetaNumberOptionsBaseNew.fromMap(Map<String, dynamic> map) {
  //   return decimalCount != null ? {'decimalDigits': decimalCount!} : null;
  // }

}

/// Options:
/// * decimalDigits
@immutable
class MetaNumberOptionsBase {
  final int? decimalCount;
  const MetaNumberOptionsBase({this.decimalCount});

  Map<String, dynamic>? toMap() {
    return decimalCount != null ? {'decimalDigits': decimalCount} : null;
  }
}

/// Options:
/// * decimalDigits
/// * name
@immutable
class MetaNumberOptionsSimple extends MetaNumberOptionsBase {
  final String? name;
  const MetaNumberOptionsSimple({this.name, int? decimalCount})
      : super(decimalCount: decimalCount);

  @override
  Map<String, dynamic>? toMap() {
    final Map<String, dynamic>? out = super.toMap();
    final Map<String, String>? simple = name != null ? {'name': name!} : null;
    return (out != null || simple != null) ? {...?out, ...?simple} : null;
  }
}

/// Options:
/// * decimalDigits
/// * name
/// * symbol
@immutable
class MetaNumberOptionsExtended extends MetaNumberOptionsSimple {
  final String? symbol;
  const MetaNumberOptionsExtended(
      {this.symbol, String? name, int? decimalCount})
      : super(name: name, decimalCount: decimalCount);

  @override
  Map<String, dynamic>? toMap() {
    final Map<String, dynamic>? out = super.toMap();
    final Map<String, String>? extended =
        symbol != null ? {'symbol': symbol!} : null;
    return (out != null || extended != null) ? {...?out, ...?extended} : null;
  }
}

/// Options:
/// * decimalDigits
/// * name
/// * symbol
/// * pattern
@immutable
class MetaNumberOptionsFull extends MetaNumberOptionsExtended {
  final String? pattern;
  const MetaNumberOptionsFull({
    this.pattern,
    String? symbol,
    String? name,
    int? decimalCount,
  }) : super(symbol: symbol, name: name, decimalCount: decimalCount);

  @override
  Map<String, dynamic>? toMap() {
    final Map<String, dynamic>? full = super.toMap();
    final Map<String, String>? extended =
        pattern != null ? {'customPattern': pattern!} : null;
    return (full != null || extended != null) ? {...?full, ...?extended} : null;
  }
}
