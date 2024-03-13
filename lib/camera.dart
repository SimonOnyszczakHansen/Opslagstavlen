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
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    await cameraProvider.initializeCameras();
    if (cameraProvider.cameras != null && cameraProvider.cameras!.isNotEmpty) {
      _controller = CameraController(
          cameraProvider.cameras!.first, ResolutionPreset.ultraHigh);
      _controller.addListener(() {
        if (mounted) setState(() {});
      });
      await _controller.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

Future<void> _takePicture() async {
  try {
    final image = await _controller.takePicture();
    // Upload the image after capturing
    await _uploadImage(image);
    // Optionally save the image path locally if the upload succeeds
    Provider.of<ImageStorageProvider>(context, listen: false).saveImagePath(image.path);
  } catch (e) {
    print(e.toString());
  }
}

  Future<void> _uploadImage(XFile image) async {
  var uri = Uri.parse('http://10.0.2.2:3000/api/upload');
  var request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('image', image.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    print('Image uploaded successfully');
  } else {
    print('Failed to upload image');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      drawer: const BurgerMenu(),
      body: _controller.value.isInitialized
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CameraPreview(_controller),
                ),
                FloatingActionButton(
                  onPressed: _takePicture,
                  child: const Icon(Icons.camera),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
