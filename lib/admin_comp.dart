import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Complaint {
  String complaintID;
  String complaintType;
  String complaintDescription;
  String complaintLocation;
  String complaintfrom;

  Complaint(
      {required this.complaintID,
      required this.complaintType,
      required this.complaintDescription,
      required this.complaintLocation,
      required this.complaintfrom});
}

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('complaints').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var complaints = snapshot.data!.docs
              .map((doc) => Complaint(
                  complaintID: doc.id,
                  complaintType: doc['type'],
                  complaintDescription: doc['description'],
                  complaintLocation: doc['address'],
                  complaintfrom: doc['user']))
              .toList();

          var waterComplaints = complaints
              .where((complaint) => complaint.complaintType == 'water')
              .toList();
          var roadComplaints = complaints
              .where((complaint) => complaint.complaintType == 'road')
              .toList();

          return ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Unresolved Complaints',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              ExpansionTile(
                title: const Text('Water Complaints'),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: waterComplaints.length,
                    itemBuilder: (BuildContext context, int index) {
                      var complaint = waterComplaints[index];
                      return ListTile(
                        title: Text(complaint.complaintDescription),
                        subtitle: Text(complaint.complaintLocation),
                        trailing: Text(complaint.complaintfrom),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              ExpansionTile(
                title: const Text('Road Complaints'),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: roadComplaints.length,
                    itemBuilder: (BuildContext context, int index) {
                      var complaint = roadComplaints[index];
                      return ListTile(
                        title: Text(complaint.complaintDescription),
                        subtitle: Text(complaint.complaintLocation),
                        trailing: Text(complaint.complaintfrom),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
