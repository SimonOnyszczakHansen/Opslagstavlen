import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ImageStorageProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveImagePath(String path) async {
    final List<String> imagePaths = await getSavedImagePaths() ?? [];
    imagePaths.add(path);
    await _storage.write(key: 'image_paths', value: jsonEncode(imagePaths));
    notifyListeners();
  }

  Future<List<String>?> getSavedImagePaths() async {
    final String? pathsString = await _storage.read(key: 'image_paths');
    return pathsString != null ? List<String>.from(json.decode(pathsString)) : [];
  }
}
