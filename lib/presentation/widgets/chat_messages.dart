import 'package:chitchat/app_logic/controller/chat_controller.dart';
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
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageBubble = MessageBubble(
              displayName: message.data()[colDisplayName],
              //TODO: switch to decrypt function
              textWidget: Chat().decryptText2(
                widget.userUID,
                widget.targetUID,
                message.data()[colEncryptedText],
              ),
              text: message.data()[colEncryptedText],
              senderEmail: message.data()[colEmail],
              isMe: widget.userUID == message.data()[colUID],
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}
