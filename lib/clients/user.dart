import 'package:cloud_firestore/cloud_firestore.dart';

class UserClient {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(
    String userId,
    String userName,
  ) async {
    await users.doc(userId).set({'name': userName}).catchError(
        (error) => print("Failed to register users: $error"));
  }

  Future<Map<String, String>> getUser(String userId) async {
    String userName = '';

    await users.doc(userId).get().then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      userName = data['name'] as String;
    }).catchError((error) => print("Failed to get average prices: $error"));

    return Future(() => {"userName": userName});
  }
}
