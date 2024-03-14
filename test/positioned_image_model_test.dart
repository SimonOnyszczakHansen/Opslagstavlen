import 'package:flutter_test/flutter_test.dart';
import '../lib/models/positioned_image_model.dart';

void main() {
  group('positioned image', () { // Start a group of tests for the PositionedImage model
    test('initializes with the correct imagePath and position', () {
      const String imagePath = 'test_image_path'; // Define a constant string for the image path
      const Offset position = Offset(10, 20); // Define a constant Offset for the position

      final PositionedImage positionedImage = PositionedImage(imagePath: imagePath, position: position); // Create a new PositionedImage instance

      // Check that the imagePath and position of the PositionedImage instance are equal to the expected values
      expect(positionedImage.imagePath, imagePath);
      expect(positionedImage.position, position);
    });
  });
}