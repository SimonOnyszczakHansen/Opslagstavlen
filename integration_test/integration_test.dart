import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_2/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('takes a picture and uploads it', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final Finder cameraButton = find.byKey(const Key('cameraButton'));
    await tester.tap(cameraButton);
    await tester.pumpAndSettle();

    final Finder captureButton = find.byKey(const Key('captureButton'));
    await tester.tap(captureButton);
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5));

    expect(find.text('Image uploaded successfully'), findsOneWidget);
  });
}