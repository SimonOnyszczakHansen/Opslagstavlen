import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/camera_provider.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text('Burger Menu'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            title: const Text('Camera'),
            onTap: () async {
              final provider = context.read<CameraProvider>();
              await provider.initializeCameras();
              context.go('/camera');
            },
          ),
          ListTile(
              title: const Text('Gallery'),
              onTap: () => context.go('/gallery')),
        ],
      ),
    );
  }
}
