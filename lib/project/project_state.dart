import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/language/language_data.dart';
import 'package:potato/project/project_file.dart';

@immutable
class ProjectState {
  final ProjectFile file;
  final LanguageData languageData;

  ProjectState({ProjectFile? projectFile, LanguageData? languageData})
      : file = projectFile ?? const ProjectFile(),
        languageData = languageData ?? LanguageData();

  ProjectState copyWith({
    ProjectFile? file,
    LanguageData? languageData,
  }) {
    return ProjectState(
      projectFile: file ?? this.file,
      languageData: languageData ?? this.languageData,
    );
  }

  @override
  String toString() => 'ProjectState(file: $file, languageData: $languageData)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectState && other.file == file && other.languageData == languageData;
  }

  @override
  int get hashCode => file.hashCode ^ languageData.hashCode;
}
