import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

import '../potato_logger.dart';

final Provider<FilePickerService> filePickerProvider =
    Provider<FilePickerService>((ProviderRef<FilePickerService> ref) {
  return FilePickerService(ref.watch(loggerProvider));
});

class FilePickerService {
  FilePickerService(this._logger);
  final Logger _logger;

  Future<File?> pickFile() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: <String>['.potato']);

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      _logger.i('File picker aborted');
      return null;
    }
  }

  Future<String?> saveFile() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'output-file.pdf',
    );

    if (outputFile == null) {
      _logger.i('Save file aborted');
      // User canceled the picker
    }
  }
}
