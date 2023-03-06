import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    login(_emailController.text, _passwordController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login(String email, String password) {
    FirebaseFirestore.instance
        .collection('users')
        .where('uname', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.length == 1) {
        // Successful login
        print('Login successful!');
        // Navigate to home screen or do something else
      } else {
        // Failed login
        print('Invalid email or password');
      }
    }).catchError((error) {
      // Error occurred while querying Firestore
      print('Error logging in: $error');
    });
  }
}
