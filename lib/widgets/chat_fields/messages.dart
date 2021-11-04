import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'chat_container.dart';

class Messages extends StatelessWidget {
  final String roomId;
  const Messages({
    Key key,
    this.roomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(roomId)
            .collection('messages')
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (context, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: kPrimaryColor,
            ));
          }
          final chatDocs = chatSnapshot.data.docs;
          final userId = FirebaseAuth.instance.currentUser;
          return chatDocs != null
              ? ListView.builder(
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) => ChatContainer(
                    text: chatDocs[index].data()['text'],
                    userId: userId.uid,
                    isMe: chatDocs[index].data()['userId'] == userId.uid,
                  ),
                )
              : null;
        });
  }
}
