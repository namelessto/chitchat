import 'package:flutter/material.dart';
import 'package:chitchat/presentation/screens/chat_screen.dart';

class ChatCard extends StatelessWidget {
  ChatCard({this.displayName, this.email, this.userID, this.image});

  final String userID;
  final String displayName;
  final String email;
  final String image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: image != null ? NetworkImage(image) : AssetImage('assets/profile-pic.png'),
      ),
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
