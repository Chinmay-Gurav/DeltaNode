import 'package:flutter/material.dart';
import 'package:delta/sign_up.dart';
import 'package:delta/setup.dart';
import 'package:delta/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: const SignUpPage(),
                            type: PageTransitionType
                                .rightToLeft, // choose your transition type
                          ),
                        );
                      },
                      child: const Text('Sign-Up'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Authenticate user using email and password
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        setData(userCredential.user!.email!);

        // Check if user exists in Firestore collection
        final DocumentSnapshot docSnapshot =
            await myCollectionRef.doc(userCredential.user!.email).get();

        if (docSnapshot.exists) {
          // navigate to home
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // navigate to set-up
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Set()),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Authentication failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password!')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> setData(useremail) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('uid', useremail);
  }

// navigation to set-up or home??
  final CollectionReference myCollectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> getto() async {
    try {
      DocumentSnapshot docSnapshot =
          await myCollectionRef.doc(_emailController.text.trim()).get();

      if (docSnapshot.exists) {
        // navigate to home
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Set()),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting field: $e');
    }
  }
}
