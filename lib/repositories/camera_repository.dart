import 'package:camera/camera.dart';

// Implements the Repository pattern to abstract camera operations.
class CameraRepository {
  // Camera controller for interacting with the camera hardware.
  CameraController? _controller;
  
  // List of detected camera devices.
  List<CameraDescription>? cameras;

  // Initializes cameras and sets up the controller.
  Future<void> initializeCameras() async {
    // Fetches available cameras.
    cameras = await availableCameras();
    
    // Initializes controller with the first camera if available.
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras!.first, ResolutionPreset.max);
      await _controller!.initialize();
    } else {
      // Logs if no cameras are found.
      print('No cameras available');
    }
  }

  // Exposes the camera controller for external use.
  CameraController? get controller => _controller;

  // Takes a picture and returns the file.
  Future<XFile?> takePicture() async {
    if (_controller != null) {
      return await _controller!.takePicture();
    }
    return null;
  }

  // Disposes the camera controller.
  void dispose() {
    _controller?.dispose();
  }
}
