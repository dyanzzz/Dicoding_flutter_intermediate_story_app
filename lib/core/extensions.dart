import 'dart:io';

import 'package:image_picker/image_picker.dart';

extension ToFile on Future<XFile?> {
  Future<File?> toFile() async {
    final XFile? xFile = await this;
    return xFile != null ? File(xFile.path) : null;
  }
}
