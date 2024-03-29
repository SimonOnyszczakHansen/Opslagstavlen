import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/burger_menu.dart'; // Update with your actual import path
import 'package:provider/provider.dart';
import 'package:camera/camera.dart'; 
import '../providers/image_storage_provider.dart'; // Update with your actual import path
import '../providers/camera_provider.dart'; // Update with your actual import path
import 'package:http/http.dart' as http; 
import 'package:flutter/foundation.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    await cameraProvider.initializeCameras();
    if (cameraProvider.controller != null) {
      setState(() {
        controller = cameraProvider.controller;
      });
      controller?.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  Future<String> encodeImageToBase64(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      print('Camera controller is not initialized.');
      return;
    }
    try {
      final XFile? image = await controller?.takePicture();
      if (image != null) {
        await _uploadImage(image);
        Provider.of<ImageStorageProvider>(context, listen: false).saveImagePath(image.path);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _uploadImage(XFile image) async {
    try {
      final base64Image = await compute(encodeImageToBase64, image.path);
      var uri = Uri.parse('http://10.0.2.2:3000/api/upload');
      var request = http.MultipartRequest('POST', uri)
        ..fields['image'] = base64Image;
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      drawer: const BurgerMenu(),
      body: controller != null && controller!.value.isInitialized
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CameraPreview(controller!), // Safely using the controller after checking it's not null and initialized
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