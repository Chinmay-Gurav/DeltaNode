import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropdownAddr extends StatefulWidget {
  final Function(String)? onChanged;
  const DropdownAddr({Key? key, this.onChanged}) : super(key: key);

  @override
  State<DropdownAddr> createState() => _DropdownAddrState();
}

class _DropdownAddrState extends State<DropdownAddr> {
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
    return DropdownButton(
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
    );
  }

  void _loadDropdownValues() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final userDoc = await usersCollection.doc(uid).get();
    final addrList = userDoc.get('addr') as List<dynamic>;
    final values = addrList.map((addr) => addr.toString()).toList();
    setState(() {
      _dropdownValues = values;
    });
  }

  Future<void> getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    uid = pref.getString('uid');
    _loadDropdownValues();
    setState(() {});
  }
}
