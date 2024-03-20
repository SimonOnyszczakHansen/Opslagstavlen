import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/burger_menu.dart'; // Import the BurgerMenu widget
import 'dart:io';
import '../providers/image_storage_provider.dart';
import 'package:provider/provider.dart';
import '../models/positioned_image_model.dart'; // Import the PositionedImage model

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  GalleryPageState createState() => GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {
  // List to store the PositionedImage objects for the bulletin board
  List<PositionedImage> bulletinBoardImages = [];

  // Set to store the image paths for the bulletin board
  Set<String> bulletinBoardImagePaths = Set();

  // Function to fetch the list of image paths from the ImageStorageProvider
  Future<List<String>> fetchImagePaths() async {
    List<String>? paths =
        await Provider.of<ImageStorageProvider>(context, listen: false)
            .getSavedImagePaths();
    // Filter out the image paths that are already in the bulletin board
    return paths
            ?.where((path) => !bulletinBoardImagePaths.contains(path))  
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Gallery')), // App bar with the title "Gallery"
      drawer: const BurgerMenu(), // Drawer menu
      body: Column(
        children: [
            Expanded(
              child: Stack(
                children: bulletinBoardImages.map((positionedImage) {
                  return Positioned(
                    left: positionedImage.position.dx,
                    top: positionedImage.position.dy,
                    child: Draggable<String>(
                      // Draggable widget to move the PositionedImage objects around the bulletin board
                      data: positionedImage.imagePath,
                      feedback: Material(
                        elevation: 4.0,
                        child: Image.file(File(positionedImage.imagePath),
                            width: 100, height: 100),
                      ),
                      childWhenDragging: Container(),
                      onDragEnd: (details) {
                        setState(() {
                          positionedImage.position = details.offset;                          
                        });
                      },
                      child: Image.file(File(positionedImage.imagePath),
                          width: 100, height: 100),
                    ),
                  );
                }).toList(),
              ),
            ),
          Container(
            height: 100,
            color: Colors.pink,
            child: FutureBuilder<List<String>>(
              future: fetchImagePaths(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Loading indicator while fetching image paths
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Error: ${snapshot.error}')); // Error message if there is an error fetching image paths
                } else {
                  // ListView builder to display the draggable images
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String imagePath = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Draggable<String>(
                          // Draggable widget to move the images from the list to the bulletin board
                          data: imagePath,
                          feedback: Material(
                            elevation: 4.0,
                            child: Image.file(File(imagePath),
                                width: 100, height: 100),
                          ),
                          childWhenDragging: Container(),
                          onDraggableCanceled: (velocity, offset) {
                            setState(() {
                              // Addthe image path and PositionedImage object to the bulletin board
                              bulletinBoardImagePaths.add(imagePath);
                              bulletinBoardImages.add(
                                PositionedImage(
                                    imagePath: imagePath, position: offset),
                              );
                            });
                          },
                          child: Image.file(File(imagePath),
                              width: 100, height: 100),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
