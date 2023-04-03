import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta/model/user.dart';

class FireBaseHelper {
  static FirebaseFirestore ff = FirebaseFirestore.instance;
  static CollectionReference userCollection = ff.collection('users');

  // static Stream<List<User>> getUsers() {
  //   return userCollection.snapshots().map((event) => event.docs
  //       .map((user) => User.fromJson(user.data() as Map<String, dynamic>))
  //       .toList());
  // }

  static Future<User> getUser(String uId) async {
    var user = await userCollection.doc(uId).get();
    return User.fromJson(user.data() as Map<String, dynamic>);
  }
}
