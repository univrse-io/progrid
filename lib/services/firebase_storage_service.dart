import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final _towersPath = kDebugMode ? 'towers_dev' : 'towers';

  Future<String> uploadTowerImage(String id, {required File file}) async {
    final fileName =
        '$_towersPath/$id/${DateTime.now().microsecondsSinceEpoch}';
    final storageRef = FirebaseStorage.instance.ref(fileName);
    final snapshot = await storageRef.putFile(file);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
