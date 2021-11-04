import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ShowUsersScreen extends StatelessWidget {
  static const routeName = '\show-users-screen';
  const ShowUsersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start chat'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: kPrimaryColor,
            ));
          }
          final userDocs = userSnapshot.data.docs;
          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(userDocs[index].data()['username']),
                  onTap: () async {
                    final currentUsername = await DataBase.getCurentUsername();
                    List<String> users = [
                      currentUsername,
                      userDocs[index].data()['username']
                    ];
                    Map<String, dynamic> chatroom = {
                      'users': users,
                      'roomId': getChatRoomId(
                          currentUsername, userDocs[index].data()['username']),
                    };
                    DataBase.createChatRoom(
                        chatroom,
                        getChatRoomId(currentUsername,
                            userDocs[index].data()['username']));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
