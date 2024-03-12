import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider with ChangeNotifier {
  CameraController? _controller;
  List<CameraDescription>? cameras;

  CameraController? get controller => _controller;

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras!.first, ResolutionPreset.max);
      await _controller!.initialize();
      notifyListeners();
    } else {
      print('No cameras available');
    }
  }

  Future<XFile?> takePicture() async {
    final XFile image = await _controller!.takePicture();
    return image;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}