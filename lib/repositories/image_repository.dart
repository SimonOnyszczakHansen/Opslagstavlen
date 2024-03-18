import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Manages the storage of image paths using flutter_secure_storage for enhanced security.
class ImageRepository {
  // Instance of FlutterSecureStorage for secure data storage.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Saves a new image path securely. If paths already exist, it retrieves them,
  // adds the new path, and then stores the updated list.
  Future<void> saveImagePath(String path) async {
    // Retrieve existing image paths, add the new path, then re-encode and save.
    final List<String> imagePaths = await getSavedImagePaths() ?? [];
    imagePaths.add(path);
    await _storage.write(key: 'image_paths', value: jsonEncode(imagePaths));
  }

  // Retrieves and decodes the stored list of image paths. Returns an empty list if none are found.
  Future<List<String>?> getSavedImagePaths() async {
    // Reads the stored image paths string, decodes it, and returns the list.
    final String? pathsString = await _storage.read(key: 'image_paths');
    return pathsString != null ? List<String>.from(json.decode(pathsString)) : [];
  }
}
