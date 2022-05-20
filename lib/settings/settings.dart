// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';

enum EmptyTranslation { exportEmpty, noExport, copyMainLanguage }

@immutable
class Settings {
  final EmptyTranslation? emptyTranslation;
  final Map<String, String>? apiKeys;

  const Settings({this.emptyTranslation, this.apiKeys});

  @override
  String toString() =>
      'Settings(emptyTranslation: $emptyTranslation, deeplApiKey: $apiKeys)';

  Settings copyWith({
    EmptyTranslation? emptyTranslation,
    Map<String, String>? apiKeys,
  }) {
    return Settings(
      emptyTranslation: emptyTranslation ?? this.emptyTranslation,
      apiKeys: apiKeys ?? this.apiKeys,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings &&
        other.emptyTranslation == emptyTranslation &&
        other.apiKeys == apiKeys;
  }

  @override
  int get hashCode => emptyTranslation.hashCode ^ apiKeys.hashCode;
}
