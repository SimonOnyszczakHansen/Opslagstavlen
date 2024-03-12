import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CameraProvider with ChangeNotifier {
  CameraController? _controller;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  List<CameraDescription>? cameras;

  CameraController? get controller => _controller;

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras!.first, ResolutionPreset.max);
      try {
        await _controller!.initialize();
        notifyListeners();
      } catch (e) {
        print('Error initializing camera: $e');
      }
    } else {
      print('No camera is available');
    }
  }

  Future<void> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Error: Camera not initialized.');
      return;
    }
    try {
      final XFile image = await _controller!.takePicture();
      await saveImagePath(image.path);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}