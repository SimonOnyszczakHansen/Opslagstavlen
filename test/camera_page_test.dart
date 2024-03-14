import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../lib/camera.dart';

void main() {
  group('CameraPage', () {
    late CameraController controller;

    setUp(() async {
      final cameras = await availableCameras();
      controller = CameraController(cameras.first, ResolutionPreset.medium);
      await controller.initialize();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('displays the camera preview and a capture button', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<CameraController>(
          create: (_) => controller,
          child: const MaterialApp(
            home: CameraPage(),
          ),
        ),
      );

      // Find the camera preview widget
      final Finder cameraPreviewFinder = find.byType(CameraPreview);

      // Check that the camera preview widget is displayed on the screen
      expect(cameraPreviewFinder, findsOneWidget);

      // Find the capture button widget
      final Finder captureButtonFinder = find.byType(FloatingActionButton);

      // Check that the capture button widget is displayed on the screen
      expect(captureButtonFinder, findsOneWidget);
    });
  });
}