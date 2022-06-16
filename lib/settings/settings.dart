// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';

enum EmptyTranslation { exportEmpty, noExport, copyMainLanguage }

@immutable
class Settings {
  final EmptyTranslation? emptyTranslation;

  const Settings({this.emptyTranslation});

  Settings copyWith({
    EmptyTranslation? emptyTranslation,
  }) {
    return Settings(
      emptyTranslation: emptyTranslation ?? this.emptyTranslation,
    );
  }

  @override
  String toString() => 'Settings(emptyTranslation: $emptyTranslation)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings && other.emptyTranslation == emptyTranslation;
  }

  @override
  int get hashCode => emptyTranslation.hashCode;
}
