import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/potato_logger.dart';

final AutoDisposeProvider<FilePickerService> filePickerProvider =
    Provider.autoDispose<FilePickerService>((ProviderRef<FilePickerService> ref) {
  return FilePickerService(ref.watch(loggerProvider));
});

class FilePickerService {
  FilePickerService(this._logger);
  final Logger _logger;

  static const String extension = 'potato';

  Future<File?> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(dialogTitle: 'Open project', type: FileType.custom, allowedExtensions: [extension]);

    if (result == null) {
      _logger.v('File picker aborted');
      return null;
    }

    return File(result.files.single.path!);
  }

  Future<String?> pickDirectory() async {
    final String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      _logger.v('File picker aborted');
      return null;
    }

    return selectedDirectory;
  }

  Future<String?> saveFile() async {
    String? outputFilePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save project',
      type: FileType.custom,
      allowedExtensions: [extension],
      lockParentWindow: true,
    );

    if (outputFilePath == null) {
      _logger.v('Save file aborted');
      return null;
    }

    // validate path has the extension
    if (!outputFilePath.endsWith('.$extension')) {
      outputFilePath += '.$extension';
    }

    return outputFilePath;
  }
}
