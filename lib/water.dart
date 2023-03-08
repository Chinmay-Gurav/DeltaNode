import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  String? userinfo;
  @override
  void initState() {
    super.initState();
    getData();
  }

  final _formKey = GlobalKey<FormState>();
  late String _subject;
  late String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Complaint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the subject of your issue';
                  }
                  return null;
                },
                onSaved: (value) {
                  _subject = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description of your issue!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String? addr = await getUserAddress(userinfo);

      // Save the complaint to the Firestore database
      FirebaseFirestore.instance.collection('complaints').add({
        'subject': _subject,
        'description': _description,
        'timestamp': DateTime.now(),
        'type': 'water',
        'uname': userinfo,
        'address': addr,
      });

      // Show a success message and go back to the previous screen
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Complaint submitted'),
          content:
              const Text('Your complaint has been submitted successfully.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    userinfo = pref.getString('uname');
    setState(() {});
  }

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<String> getUserAddress(String? username) async {
    DocumentSnapshot snapshot = await usersCollection.doc(username).get();
    String address = snapshot.get('addr');
    return address;
  }
}
