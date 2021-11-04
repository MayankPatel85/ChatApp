import 'package:chat_app/widgets/chat_fields/chat_input.dart';
import 'package:chat_app/widgets/chat_fields/messages.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat-scrren';

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;

    final roomId =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(roomId['roomId']
                .toString()
                .replaceAll('_', '')
                .replaceAll(roomId['userName'], '')),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Messages(
            roomId: roomId['roomId'],
          )),
          ChatInput(
            roomId: roomId['roomId'],
          ),
        ],
      ),
    );
  }
}
