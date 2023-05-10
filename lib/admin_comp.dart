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
  List<Complaint> _waterComplaints = [];
  List<Complaint> _roadComplaints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: FutureBuilder<List<Complaint>>(
        future: _getComplaints(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          _waterComplaints = snapshot.data!
              .where((complaint) => complaint.complaintType == 'water')
              .toList();
          _roadComplaints = snapshot.data!
              .where((complaint) => complaint.complaintType == 'road')
              .toList();

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: const TabBar(
                tabs: [
                  Tab(text: 'Water Complaints'),
                  Tab(text: 'Road Complaints'),
                ],
              ),
              body: TabBarView(
                children: [
                  ListView.builder(
                    itemCount: _waterComplaints.length,
                    itemBuilder: (BuildContext context, int index) {
                      var complaint = _waterComplaints[index];
                      return ListTile(
                        title: Text(complaint.complaintDescription),
                        subtitle: Text(complaint.complaintLocation),
                        trailing: Text(complaint.complaintfrom),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: _roadComplaints.length,
                    itemBuilder: (BuildContext context, int index) {
                      var complaint = _roadComplaints[index];
                      return ListTile(
                        title: Text(complaint.complaintDescription),
                        subtitle: Text(complaint.complaintLocation),
                        trailing: Text(complaint.complaintfrom),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Complaint>> _getComplaints() async {
    final QuerySnapshot snapshot = await _db.collection('complaints').get();
    return snapshot.docs
        .map((doc) => Complaint(
            complaintID: doc.id,
            complaintType: doc['type'],
            complaintDescription: doc['description'],
            complaintLocation: doc['address'],
            complaintfrom: doc['user']))
        .toList();
  }
}
