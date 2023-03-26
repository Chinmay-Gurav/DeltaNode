import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delta/dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Water extends StatefulWidget {
  const Water({super.key});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  String? uid;
  File? _image;
  @override
  void initState() {
    super.initState();
    getData();
  }

  final _formKey = GlobalKey<FormState>();
  late String _subject;
  late String _description;
  late String _selectedValue;

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
                decoration: const InputDecoration(
                    labelText: 'Subject', border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
                onSaved: (value) {
                  _subject = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownAddr(
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              // pick img from camera
              IconButton(
                  onPressed: () {
                    _getImage();
                  },
                  icon: const Icon(Icons.camera)),
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

      // List addr = await getUserAddress(uid); --->>not required....was just a temp_soln to take addr[0] as default.
      if (_image != null) {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('complaints/${DateTime.now().toString()}');
        final uploadTask = storageRef.putFile(_image!);
        // Display progress bar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: SizedBox(
              height: 50,
              child: Center(
                child: StreamBuilder(
                  stream: uploadTask.snapshotEvents,
                  builder: (BuildContext context,
                      AsyncSnapshot<TaskSnapshot> snapshot) {
                    var event = snapshot.data;
                    double? progressPercentage;
                    if (event != null) {
                      progressPercentage =
                          event.bytesTransferred / event.totalBytes;
                    }
                    return CircularProgressIndicator(
                      value: progressPercentage,
                    );
                  },
                ),
              ),
            ),
          ),
        );
        // Wait for image upload to complete
        await uploadTask.whenComplete(() => null);
        // Get image URL from Firebase Storage and save it to Firestore
        final imageUrl = await storageRef.getDownloadURL();
        // Save the complaint to the Firestore database
        FirebaseFirestore.instance.collection('complaints').add({
          'subject': _subject,
          'description': _description,
          'timestamp': DateTime.now(),
          'type': 'water',
          'user': uid,
          'address': _selectedValue,
          'image': imageUrl,
        });
        // Show a success message and go back to the previous screen
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Close progress bar dialog
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
      if (_image == null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No Image Found!')),
        );
      }
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // print('No image selected.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No Image Found!')),
        );
      }
    });
  }

  void getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    uid = pref.getString('uid');
    setState(() {});
  }

  // final CollectionReference usersCollection =
  //     FirebaseFirestore.instance.collection('users');
  //
  // Future<List> getUserAddress(String? username) async {
  //   DocumentSnapshot snapshot = await usersCollection.doc(username).get();
  //   List address = snapshot.get('addr');
  //   return address;
  // }  not required anymore - just a fn to get addr
}
