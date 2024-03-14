import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/camera_provider.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the Drawer widget to create a side menu
    return Drawer(
      child: ListView(
        // Use ListView to create a scrollable list of items
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            // DrawerHeader widget to add a header to the Drawer
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text('Burger Menu'), // Add a title to the header
          ),
          ListTile(
            // ListTile widget to create a list item
            title: const Text('Home'), // Add a title to the list item
            onTap: () => context.go('/'), // Navigate to the home page when the list item is tapped
          ),
          ListTile(
            // ListTile widget to create a list item
            title: const Text('Camera'), // Add a title to the list item
            onTap: () async {
              // Initialize the camera when the list item is tapped
              final provider = context.read<CameraProvider>();
              await provider.initializeCameras();
              context.go('/camera'); // Navigate to the camera page after initializing the camera
            },
          ),
          ListTile(
            // ListTile widget to create a list item
            title: const Text('Gallery'), // Add a title to the list item
            onTap: () => context.go('/gallery'), // Navigate to the gallery page when the list item is tapped
          ),
        ],
      ),
    );
  }
}