// Import statements
import 'package:flutter/material.dart';
import 'package:flutter_application_2/burger_menu.dart';
import 'dart:io';
import 'providers/image_provider.dart';
import 'package:provider/provider.dart';
import 'models/positioned_image_model.dart'; // Make sure to import the PositionedImage model here

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  GalleryPageState createState() => GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {
  List<PositionedImage> bulletinBoardImages = [];
  Set<String> bulletinBoardImagePaths = Set();

  Future<List<String>> fetchImagePaths() async {
    List<String>? paths = await Provider.of<ImageStorageProvider>(context, listen: false).getSavedImagePaths();
    return paths?.where((path) => !bulletinBoardImagePaths.contains(path)).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      drawer: const BurgerMenu(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: bulletinBoardImages.map((positionedImage) {
                return Positioned(
                  left: positionedImage.position.dx,
                  top: positionedImage.position.dy,
                  child: Draggable<String>(
                    data: positionedImage.imagePath,
                    feedback: Material(
                      elevation: 4.0,
                      child: Image.file(File(positionedImage.imagePath), width: 100, height: 100),
                    ),
                    childWhenDragging: Container(),
                    onDragEnd: (details) {
                      setState(() {
                        positionedImage.position = details.offset;
                      });
                    },
                    child: Image.file(File(positionedImage.imagePath), width: 100, height: 100),
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
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Draggable Image Footer
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String imagePath = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Draggable<String>(
                          data: imagePath,
                          feedback: Material(
                            elevation: 4.0,
                            child: Image.file(File(imagePath), width: 100, height: 100),
                          ),
                          childWhenDragging: Container(),
                          onDraggableCanceled: (velocity, offset) {
                            setState(() {
                              bulletinBoardImagePaths.add(imagePath);
                              bulletinBoardImages.add(
                                PositionedImage(imagePath: imagePath, position: offset),
                              );
                            });
                          },
                          child: Image.file(File(imagePath), width: 100, height: 100),
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

