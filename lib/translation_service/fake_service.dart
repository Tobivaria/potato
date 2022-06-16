import 'package:flutter/foundation.dart';
import 'package:potato/translation_service/translation_service.dart';
import 'package:potato/translation_service/usage.dart';

class FakeService extends TranslationService {
  FakeService({
    required super.preferencesRepository,
    required super.translationConfig,
    required super.client,
    required super.name,
  }) : super();

  @override
  Future<String> translate(String toTranslate) async {
    return Future.delayed(const Duration(seconds: 1), () => 'Some fake string');
  }

  @override
  Future<FakeUsage?> getUsage() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () => const FakeUsage(5923, 50000),
    );
  }

  @override
  String getName() {
    return 'Fake';
  }
}

@immutable
class FakeUsage extends Usage {
  final int _usedChars;
  final int _availableChars;

  const FakeUsage(this._usedChars, this._availableChars)
      : super(_usedChars, _availableChars);

  @override
  String toString() {
    return 'FakeUsage(usedChars: $_usedChars, availableChars: $_availableChars)';
  }
}
