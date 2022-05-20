import 'package:flutter/foundation.dart';
import 'package:potato/translation_service/translation_service.dart';
import 'package:potato/translation_service/usage.dart';

class FakeService extends TranslationService {
  FakeService(
      {required super.preferencesRepository,
      required super.fakeConfig,
      required super.translationConfig,
      required super.client});

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
class FakeConfig {
  final String authKey;
  late final String tagHandling;

  /// tag which will replace placeholders in the request
  /// these tags are also ignored, and will not be translated
  late final String replacePlaceholderTag;

  FakeConfig({
    required this.authKey,
  }) {
    tagHandling = 'xml';
    replacePlaceholderTag = 'p';
  }
}

@immutable
class FakeUsage implements Usage {
  final int _usedChars;
  final int _availableChars;

  const FakeUsage(this._usedChars, this._availableChars);

  @override
  String toString() {
    return 'FakeUsage(usedChars: $_usedChars, availableChars: $_availableChars)';
  }

  @override
  int get current => _usedChars;

  @override
  int get max => _availableChars;

  @override
  double get usedPercentage => _usedChars / _availableChars * 100;
}
