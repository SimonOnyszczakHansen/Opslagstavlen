import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// A provider class for storing and retrieving image paths securely on the device.
class ImageStorageProvider with ChangeNotifier {
  // Instantiate FlutterSecureStorage to interact with secure storage.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Asynchronously saves a new image path to secure storage.
  Future<void> saveImagePath(String path) async {
    // Retrieve the current list of saved image paths, or initialize to an empty list if none.
    final List<String> imagePaths = await getSavedImagePaths() ?? [];
    imagePaths.add(path); // Add the new path to the list of saved image paths.
    // Securely store the updated list of image paths as a JSON string.
    await _storage.write(key: 'image_paths', value: jsonEncode(imagePaths));
    notifyListeners(); // Notify listeners that the stored data has changed.
  }

  // Asynchronously retrieves the list of saved image paths from secure storage.
  Future<List<String>?> getSavedImagePaths() async {
    // Read the JSON string of saved image paths from secure storage.
    final String? pathsString = await _storage.read(key: 'image_paths');
    // Decode the JSON string back into a List<String> if it exists, or return an empty list if null.
    return pathsString != null ? List<String>.from(json.decode(pathsString)) : [];
  }
}