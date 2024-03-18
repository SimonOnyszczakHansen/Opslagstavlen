import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/burger_menu.dart';
import 'package:provider/provider.dart';
import 'providers/camera_provider.dart';
import 'providers/image_provider.dart';
import 'package:go_router/go_router.dart';
import 'pages/camera.dart';
import 'pages/gallery.dart';

void main() => runApp(const MyApp());

// Initialize GoRouter with routes
final GoRouter _router = GoRouter(routes: <RouteBase>[
  // Home route
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage(title: 'Home Page'); // Returns MyHomePage as the landing page
      }),
  // Camera route
  GoRoute(
      path: '/camera',
      builder: (BuildContext context, GoRouterState state) {
        return const CameraPage(); // Returns CameraPage for camera functionalities
      }),
  // Gallery route
  GoRoute(
      path: '/gallery',
      builder: (BuildContext context, GoRouterState state) {
        return const GalleryPage(); // Returns GalleryPage to view saved images
      })
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CameraProvider()), // Provides CameraProvider to the app
        ChangeNotifierProvider(create: (_) => ImageStorageProvider()) // Provides ImageStorageProvider to the app
      ],
      child: MaterialApp.router(
        title: 'Home Page', // Set the title for the application
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Set a theme for the app
          useMaterial3: true, // Enable Material 3 design
        ),
        routerDelegate: _router.routerDelegate, // Delegate for router
        routeInformationParser: _router.routeInformationParser, // Parser for route information
        routeInformationProvider: _router.routeInformationProvider, // Provider for route information
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // Title for the home page

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Displays the title
      ),
      drawer: const BurgerMenu(), // Adds a navigation drawer
      body: Center(
        child: Text(
          'Welcome To My Application', // Displays a welcome message
          style: Theme.of(context).textTheme.headlineMedium, // Styles the text
        ),
      ),
    );
  }
}
