import 'package:flutter/material.dart';
import 'package:delta/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:delta/login_screen.dart';
import 'package:delta/loading_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoadingScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MyApp(),
      },
    );
  }
}
