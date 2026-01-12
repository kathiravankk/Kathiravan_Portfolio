import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class AppFunctions {

  static Future<Map<String, dynamic>?> pickResumeFile({
    List<String> allowedExtensions = const ['pdf', 'doc', 'docx'],
    bool returnBytes = false,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      withData: returnBytes, // if you want bytes for upload
    );

    if (result == null) return null;

    File file = File(result.files.single.path!);
    String fileName = result.files.single.name;

    Uint8List? bytes;
    if (returnBytes) {
      bytes = result.files.single.bytes;
    }

    return {
      "file": file,
      "name": fileName,
      "bytes": bytes,
    };
  }


}
