import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delta/home.dart';

class Set extends StatefulWidget {
  const Set({super.key});

  @override
  State<Set> createState() => _SetState();
}

class _SetState extends State<Set> {
  String? uid;
  @override
  void initState() {
    super.initState();
    getData();
  }

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addrController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final addr = _addrController.text;

      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final userDoc = await userRef.get();

      await userRef.set({
        'firstName': firstName,
        'lastName': lastName,
        'admin': false,
        'addr': [addr],
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addrController,
                decoration: const InputDecoration(
                  labelText: 'Address/Colony',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Addr/Colony';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Set Up Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    uid = pref.getString('uid');
    setState(() {});
  }
}
