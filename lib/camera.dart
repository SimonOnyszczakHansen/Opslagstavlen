import 'package:flutter/material.dart';
import 'package:flutter_application_2/burger_menu.dart';
import 'package:provider/provider.dart';
import 'providers/camera_provider.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => CameraProvider(),
    child: const CameraApp(),
  ));
}

class CameraApp extends StatelessWidget {
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<CameraProvider>(
        builder: (context, provider, child) {
          return provider.cameras != null && provider.cameras!.isNotEmpty
              ? const CameraPage()
              : const NoCameraAvailableScreen();
        },
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    super.initState();
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    cameraProvider.initializeCameras();
  }

    @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Camera Preview')),
          drawer: const BurgerMenu(),
          body: provider.controller?.value.isInitialized ?? false
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CameraPreview(provider.controller!),
                      Center(
                        child: FloatingActionButton(
                          onPressed: () async {
                            await provider.takePicture();
                          },
                          child: const Icon(Icons.camera),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
class NoCameraAvailableScreen extends StatelessWidget {
  const NoCameraAvailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('No camera available'),
      ),
    );
  }
}