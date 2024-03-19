import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Configuration options for Firebase
import 'package:firebase_messaging/firebase_messaging.dart'; // Firebase Cloud Messaging for push notifications
import 'package:firebase_core/firebase_core.dart'; // Core Firebase library necessary for initializing Firebase
import 'package:flutter_application_2/widgets/burger_menu.dart'; // Custom widget for the navigation drawer (burger menu)
import 'package:provider/provider.dart'; // State management package to provide and consume app-wide data
import 'providers/camera_provider.dart'; // State management for camera functionality
import 'providers/image_provider.dart'; // State management for handling images
import 'package:go_router/go_router.dart'; // Modern navigation package for Flutter
import 'screens/camera.dart'; // Screen widget for camera functionality
import 'screens/gallery.dart'; // Screen widget for gallery view
import 'services/authentication_service.dart'; // Service class for handling authentication
import 'dart:convert'; // Dart's built-in library for encoding and decoding JSON

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures that Flutter engine is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initializes Firebase with the default options
  final fcmToken = await FirebaseMessaging.instance.getToken(); // Retrieves the FCM token for the device
  print(fcmToken); // Prints the FCM token for debugging purposes
  runApp(const MyApp()); // Runs the app
}

// Initialize GoRouter with routes for app navigation
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
        ChangeNotifierProvider(create: (_) => ImageStorageProvider()), // Provides ImageStorageProvider to the app
      ],
      child: MaterialApp.router(
        title: 'Home Page', // Set the title for the application
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Set a theme for the app using deep purple color scheme
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
  // Initialize the AuthenticationService class for login functionality
  final AuthenticationService authService = AuthenticationService();

  // Function to handle login logic
  Future<void> _login() async {
    // Simulate a login process, here with a fixed delay
    await Future.delayed(const Duration(seconds: 1));

    // Prepare the login request body
    final String username = 'user1';
    final String password = '1234';
    final String jsonBody = json.encode({
      'username': username,
      'password': password,
    });

    // Attempt to login and receive a token
    final String? token = await authService.login(jsonBody);

    if (token != null) {
      // Handle successful login
      print('Login successful with token: $token');
      // Show a dialog upon successful login
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Successful'),
            content: const Text('You have been logged in.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle failed login
      print('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Displays the title of the page
      ),
      drawer: const BurgerMenu(), // Adds a navigation drawer to the page
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Center the content vertically
          children: <Widget>[
            Text(
              'Welcome To My Application', // Displays a welcome message
              style: Theme.of(context).textTheme.headlineMedium, // Styles the text
            ),
            const SizedBox(height: 20), // Adds a space between text and button
            ElevatedButton(
              onPressed: _login, // Calls the _login function when the button is pressed
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
