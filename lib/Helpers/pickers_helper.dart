import 'dart:io';
import 'package:image_picker/image_picker.dart';

mixin PickersHelper {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    XFile? file = await _picker.pickImage(source: source);
    if (file == null) return null;
    return File(file.path);
  }

  Future<List<File>> pickImages() async {
    List<XFile> data = await _picker.pickMultiImage();
    return data.map((x) => File(x.path)).toList();
  }

}
