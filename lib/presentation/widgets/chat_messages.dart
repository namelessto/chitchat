import 'package:chitchat/data/set_get_db.dart';
import 'package:chitchat/presentation/widgets/message_bubble.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  ChatMessages({this.userUID, this.targetUID});

  final String userUID;
  final String targetUID;

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetData().getChatMessages(widget.userUID, widget.targetUID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('Couldn\'t find data');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return MessageBubble(
                displayName: snapshot.data.docs[index][colDisplayName],
                senderEmail: snapshot.data.docs[index][colEmail],
                isMe: snapshot.data.docs[index][colUID] == widget.userUID,
                text: snapshot.data.docs[index][colText],
              );
            },
          );
        }
      },
    );
  }
}
