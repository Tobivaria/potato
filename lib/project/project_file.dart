import 'package:flutter/foundation.dart';

@immutable
class ProjectFile {
  final String? baseLanguage;
  final String? path;

  static const String _projectVersion = '1';

  const ProjectFile({
    this.baseLanguage,
    this.path,
  });

  factory ProjectFile.fromMap(Map<String, dynamic> map) {
    return ProjectFile(
      baseLanguage: map['baseLanguage'] ?? '', // TODO assert when baselanguage not found
      path: map['path'],
    );
  }

  Map<String, String> toMap() {
    return {'baseLanguage': baseLanguage ?? '', 'path': path ?? '', 'version': _projectVersion};
  }

  ProjectFile copyWith({
    String? baseLanguage,
    String? path,
  }) {
    return ProjectFile(
      baseLanguage: baseLanguage ?? this.baseLanguage,
      path: path ?? this.path,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectFile && other.baseLanguage == baseLanguage && other.path == path;
  }

  @override
  int get hashCode => baseLanguage.hashCode ^ path.hashCode;

  @override
  String toString() => 'ProjectFile(baseLanguage: $baseLanguage, path: $path)';
}
