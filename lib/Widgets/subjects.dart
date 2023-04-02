import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DropdownSub extends StatefulWidget {
  final Function(String)? onChanged;
  final String type;
  const DropdownSub({Key? key, this.onChanged, required this.type})
      : super(key: key);

  @override
  State<DropdownSub> createState() => _DropdownSubState();
}

class _DropdownSubState extends State<DropdownSub> {
  String? _selectedValue;
  List<String> _dropdownValues = [];
  String? uid;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
          labelText: 'Select Subject', border: OutlineInputBorder()),
      child: DropdownButton(
        value: _selectedValue,
        items: _dropdownValues.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
          });
          // Call the callback function with the selected value
          widget.onChanged?.call(value!);
        },
      ),
    );
  }

  void _loadDropdownValues() async {
    final usersCollection = FirebaseFirestore.instance.collection('Subject');
    final userDoc = await usersCollection.doc('subjects').get();
    final subList = userDoc.get(widget.type) as List<dynamic>;
    final values = subList.map((sub) => sub.toString()).toList();
    setState(() {
      _dropdownValues = values;
    });
  }

  Future<void> getData() async {
    _loadDropdownValues();
    setState(() {});
  }
}
