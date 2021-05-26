import 'package:flutter/material.dart';
import 'package:chitchat/presentation/screens/chat_screen.dart';

class ChatCard extends StatelessWidget {
  ChatCard({this.displayName, this.email, this.userID});

  final String userID;
  final String displayName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(
        displayName,
      ),
      subtitle: Text(
        email,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              targetUid: userID,
              targetDisplayName: displayName,
            ),
          ),
        );
      },
    );
  }
}
