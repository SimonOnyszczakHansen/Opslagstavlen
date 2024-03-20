import 'dart:convert';

import 'package:flutter_application_2/repositories/image_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageImageRepository implements ImageRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> saveImagePath(String path) async {
    final List<String> imagePaths = await fetchImagePaths();
    imagePaths.add(path);
    await _storage.write(key: 'image_paths', value: jsonEncode(imagePaths));
  }


  @override
  Future<List<String>> fetchImagePaths() async {
    final String? pathsString = await _storage.read(key: 'image_paths');
    return pathsString != null ? List<String>.from(json.decode(pathsString)) : [];
  }
  
}