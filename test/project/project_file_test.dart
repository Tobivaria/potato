import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/project/project_file.dart';

void main() {
  test('Create new ProjectFile', () {
    const ProjectFile project = ProjectFile(baseLanguage: 'en');
    expect(project.baseLanguage, 'en');
    expect(project.path, isNull);
  });

  test('Create projectfrom map', () {
    const String baseLanguage = 'de';
    const String path = 'some/path';

    final ProjectFile project = ProjectFile.fromMap(const {'baseLanguage': baseLanguage, 'path': path});

    expect(project.baseLanguage, 'de');
    expect(project.path, path);
  });

  test('Convert ProjectFile to map', () {
    const String baseLanguage = 'de';
    const String path = 'some/path';
    const Map<String, String> expected = {'baseLanguage': baseLanguage, 'path': path, 'version': '1'};

    const ProjectFile project = ProjectFile(baseLanguage: baseLanguage, path: path);
    expect(mapEquals(project.toMap(), expected), isTrue);
  });
}
