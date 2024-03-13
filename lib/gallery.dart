import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/burger_menu.dart';
import 'package:provider/provider.dart';
import 'providers/image_provider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<String> droppedImagePaths = []; // Store paths of dropped images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      drawer: const BurgerMenu(),
      body: Stack(
        children: [
          // Positioned.fill replaced with a more specific container for the bulletin board
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the bulletin board
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DragTarget<String>(
              onAccept: (receivedImagePath) {
                setState(() {
                  droppedImagePaths.add(receivedImagePath);
                });
              },
              builder: (
                BuildContext context,
                List<dynamic> candidateData,
                List<dynamic> rejectedData,
              ) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: droppedImagePaths.length,
                  itemBuilder: (context, index) {
                    final imagePath = droppedImagePaths[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // FutureBuilder for draggable images in the footer remains unchanged
          Align(
            alignment: Alignment.bottomCenter,
            child: FutureBuilder<List<String>?>(
              future: Provider.of<ImageStorageProvider>(context, listen: false)
                  .getSavedImagePaths(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final List<String>? imagePaths = snapshot.data;
                  if (imagePaths == null || imagePaths.isEmpty) {
                    return const SizedBox(
                      height: 100,
                      child: Center(child: Text('No images found')),
                    );
                  }
                  return SizedBox(
                    height: 100, // Footer height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imagePaths.length,
                      itemBuilder: (context, index) {
                        final imagePath = imagePaths[index];
                        return Draggable<String>(
                          data: imagePath,
                          feedback: Material(
                            elevation: 4.0,
                            child: Image.file(
                              File(imagePath),
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          childWhenDragging: Container(
                            width: 100,
                            color: Colors.grey.shade200,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                              width: 100,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                // Default return statement to ensure a widget is always returned
                return const SizedBox(
                  height: 100,
                  child: Center(child: Text('Unable to load images')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
