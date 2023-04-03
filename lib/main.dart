import 'package:flutter/material.dart';
import 'package:delta/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:delta/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? logged;
  @override
  void initState() {
    super.initState();
    getLogData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: (logged == null) ? '/login' : '/main',
      routes: {
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MyApp(),
      },
    );
  }

  void getLogData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    logged = sp.getString('LoggedIn');
    setState(() {});
  }
}
