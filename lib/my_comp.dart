import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyComplaintsPage extends StatefulWidget {
  const MyComplaintsPage({super.key});

  @override
  State<MyComplaintsPage> createState() => _MyComplaintsPageState();
}

class _MyComplaintsPageState extends State<MyComplaintsPage> {
  String? usermail;
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .where('user', isEqualTo: usermail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var complaint = snapshot.data?.docs[index];

              return ListTile(
                title: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    complaint!['subject'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                subtitle: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    complaint['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                trailing: Text(complaint['address']),
              );
            },
          );
        },
      ),
    );
  }

  void getData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    usermail = pref.getString('uid');
    setState(() {});
  }
}
