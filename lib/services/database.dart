import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBase {
  static Future<void> createChatRoom(users, roomId) async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(roomId)
        .set(users)
        .catchError((e) {
      print(e);
    });
  }

  static Future<String> getCurentUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    String userName;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) {
      userName = value.data()['username'];
    });
    return userName;
  }
}
