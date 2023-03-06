import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta/sign_up.dart';
import 'package:delta/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
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
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
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
                    login(_usernameController.text, _passwordController.text);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Sign Up'),
                onPressed: () {
                  // Navigate to sign-up screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void login(String uname, String password) {
    FirebaseFirestore.instance
        .collection('users')
        .where('uname', isEqualTo: uname)
        .where('password', isEqualTo: password)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size == 1) {
        // Successful login
        print('Login successful!');
        // Navigate to home screen or do something else
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        // Failed login
        const snackBar = SnackBar(
          content: Text('Invalid username or password'),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((error) {
      // Error occurred while querying Firestore
      print('Error logging in: $error');
    });
  }
}
