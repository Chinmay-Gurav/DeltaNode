import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            // ignore: prefer_const_literals_to_create_immutables
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/zmnag.jpg'),
              height: 100,
              width: 100,
            ),
            SizedBox(height: 40),
            Text(
              'Zimmedar Nagarik',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
