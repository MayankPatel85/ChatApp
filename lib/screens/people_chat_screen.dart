import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';
import 'show_users_screen.dart';

class PeopleChatScreen extends StatefulWidget {
  const PeopleChatScreen({Key key}) : super(key: key);

  @override
  State<PeopleChatScreen> createState() => _PeopleChatScreenState();
}

class _PeopleChatScreenState extends State<PeopleChatScreen> {
  String currentUserName;
  @override
  void initState() {
    DataBase.getCurentUsername().then((value) {
      setState(() {
        currentUserName = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _tryLogout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushNamed(AuthScreen.routeName);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ShowUsersScreen.routeName);
              },
              icon: Icon(Icons.person_add)),
          TextButton(onPressed: _tryLogout, child: Text('Logout')),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chatrooms')
              .where('users', arrayContains: currentUserName)
              .snapshots(),
          builder: (context, peopleSnapshot) {
            if (peopleSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: kPrimaryColor,
                ),
              );
            }
            final peopleDocs = peopleSnapshot.data.docs;
            // final roomId = peopleDocs.data()['roomId'];
            // print(roomId);
            return peopleSnapshot.hasData
                ? ListView.builder(
                    itemCount: peopleDocs.length,
                    itemBuilder: (ctx, index) => ListTile(
                      leading: Icon(Icons.person),
                      title: Text(peopleDocs[index]
                          .data()['roomId']
                          .toString()
                          .replaceAll('_', '')
                          .replaceAll(currentUserName, '')),
                      trailing: Icon(Icons.arrow_forward_rounded),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(ChatScreen.routeName, arguments: {
                          'userName': currentUserName,
                          'roomId': peopleDocs[index].data()['roomId'],
                        });
                      },
                    ),
                  )
                : Container();
          }),
    );
  }
}
