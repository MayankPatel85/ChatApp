import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class ChatContainer extends StatelessWidget {
  @required
  final String text;
  final String userId;
  final bool isMe;

  const ChatContainer({Key key, this.text, this.userId, this.isMe})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: !isMe ? kPrimaryLightColor : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isMe ? Radius.circular(12) : Radius.circular(0),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
