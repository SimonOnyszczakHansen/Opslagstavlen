import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider with ChangeNotifier {
  // CameraController to control the camera
  CameraController? _controller;

  // List of CameraDescription objects to store the available cameras
  List<CameraDescription>? cameras;

  // Getter for the CameraController
  CameraController? get controller => _controller;

  // Initialize the cameras and set up the first available camera
  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras!.first, ResolutionPreset.max);
      await _controller!.initialize();
      notifyListeners(); // Notify listeners that the camera has been initialized
    } else {
      print('No cameras available');
    }
  }

  // Take a picture using the camera
  Future<XFile?> takePicture() async {
    final XFile image = await _controller!.takePicture();
    return image;
  }

  // Dispose the CameraController when the provider is disposed
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}