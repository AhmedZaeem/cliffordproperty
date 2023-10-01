import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FbStorageController {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File? file, {required String path}) async {
    if (file == null) return null;

    var data = await _storage
        .ref()
        .child('$path/${DateTime.now().toString()}')
        .putFile(file);
    String fullPath = data.ref.fullPath;

    return fullPath;
  }

  Future<void> delete(String path) async {
    await _storage.ref().child(path).delete();
  }
}
