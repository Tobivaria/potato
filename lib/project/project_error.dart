import 'package:flutter/foundation.dart';

@immutable
class ProjectError {
  final String language;
  final String key;

  const ProjectError({
    required this.language,
    required this.key,
  });
}
