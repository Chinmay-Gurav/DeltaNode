import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetMen extends StatefulWidget {
  const SetMen({Key? key}) : super(key: key);

  @override
  State<SetMen> createState() => _SetMenState();
}

class _SetMenState extends State<SetMen> {
  final _addressController = TextEditingController();
  String? uid;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitAddress() async {
    final address = _addressController.text;
    if (address.isEmpty) {
      return;
    }

    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await userRef.update({
        'addr': FieldValue.arrayUnion([_addressController.text]),
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address added successfully')),
      );
      _addressController.clear();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add Address'),
                      content: TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your address',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('CANCEL'),
                        ),
                        ElevatedButton(
                          onPressed: _submitAddress,
                          child: const Text('ADD'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Add Address'),
            ),
          ],
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
