import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/burger_menu.dart';
import 'package:provider/provider.dart';
import 'providers/camera_provider.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      drawer: const BurgerMenu(),
      body: FutureBuilder<List<String>?>(
        future: Provider.of<CameraProvider>(context, listen: false).getSavedImagePaths(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<String>? imagePaths = snapshot.data;
            if (imagePaths == null || imagePaths.isEmpty) {
              return const Center(child: Text('No images found'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                final imagePath = imagePaths[index];
                return GestureDetector(
                  onTap: () {
                    // Handle image tap
                  },
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
