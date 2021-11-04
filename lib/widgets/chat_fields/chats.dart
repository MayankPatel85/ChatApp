import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class Chats extends StatelessWidget {
  final String username;
  final String lastMessage;

  Chats(this.username, this.lastMessage);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: kPrimaryLightColor,
          ),
          Expanded(
            child: Column(
              children: [
                Text(username),
                Text(lastMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
