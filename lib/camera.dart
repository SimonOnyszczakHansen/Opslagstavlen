import 'package:flutter/material.dart';
import 'package:flutter_application_2/burger_menu.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart'; 
import 'providers/image_provider.dart'; 
import 'providers/camera_provider.dart'; 
import 'package:http/http.dart' as http; 

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  late CameraController _controller; // Define a controller for camera operations

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Initialize the camera when the widget is created
  }

  Future<void> _initializeCamera() async {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false); // Access CameraProvider
    await cameraProvider.initializeCameras(); // Initialize cameras using CameraProvider
    if (cameraProvider.cameras != null && cameraProvider.cameras!.isNotEmpty) { // Check if cameras are available
      _controller = CameraController(
          cameraProvider.cameras!.first, ResolutionPreset.ultraHigh); // Initialize camera controller with the first available camera and set resolution
      _controller.addListener(() {
        if (mounted) setState(() {}); // Add listener to update UI for any changes in camera controller
      });
      await _controller.initialize(); // Initialize the camera controller
      if (mounted) setState(() {}); // Update the UI once the camera controller is initialized
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the camera controller when the widget is disposed
    super.dispose();
  }

Future<void> _takePicture() async {
  try {
    final image = await _controller.takePicture(); // Take a picture
    // Upload the image after capturing
    await _uploadImage(image);
    // Optionally save the image path locally if the upload succeeds
    Provider.of<ImageStorageProvider>(context, listen: false).saveImagePath(image.path); // Save the image path using ImageStorageProvider
  } catch (e) {
    print(e.toString()); // Print error if picture taking fails
  }
}

  Future<void> _uploadImage(XFile image) async {
  var uri = Uri.parse('http://10.0.2.2:3000/api/upload'); // Define the URI for the upload endpoint
  var request = http.MultipartRequest('POST', uri) // Create a POST request
    ..files.add(await http.MultipartFile.fromPath('image', image.path)); // Add image as multipart file

  var response = await request.send(); // Send the request

  if (response.statusCode == 200) {
    print('Image uploaded successfully'); // Print success message if upload succeeds
  } else {
    print('Failed to upload image'); // Print failure message if upload fails
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')), // App bar with title
      drawer: const BurgerMenu(), // Drawer for additional navigation options
      body: _controller.value.isInitialized
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CameraPreview(_controller), // Display camera preview if camera is initialized
                ),
                FloatingActionButton(
                  onPressed: _takePicture, // Button to take a picture
                  child: const Icon(Icons.camera),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()), // Display loading indicator while camera is initializing
    );
  }
}
