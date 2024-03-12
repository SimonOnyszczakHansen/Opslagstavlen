import 'package:flutter/material.dart';
import 'package:flutter_application_2/burger_menu.dart';
import 'package:provider/provider.dart';
import 'providers/camera_provider.dart';
import 'providers/image_provider.dart';
import 'package:go_router/go_router.dart';
import 'camera.dart';
import 'gallery.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage(title: 'Home Page');
      }),
  GoRoute(
      path: '/camera',
      builder: (BuildContext context, GoRouterState state) {
        return const CameraPage();
      }),
  GoRoute(
      path: '/gallery',
      builder: (BuildContext context, GoRouterState state) {
        return const GalleryPage();
      })
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CameraProvider()),
        ChangeNotifierProvider(create: (_) => ImageStorageProvider())
      ],
      child: MaterialApp.router(
        title: 'Home Page',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: const BurgerMenu(),
      body: Center(
        child: Text(
          'Welcome To My Application',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
