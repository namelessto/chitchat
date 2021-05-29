import 'package:chitchat/app_logic/controller/chat_controller.dart';
import 'package:chitchat/presentation/widgets/chat_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.targetUid, this.targetDisplayName});

  final String targetUid;
  final String targetDisplayName;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = new TextEditingController();
  User loggedUser;

  @override
  void initState() {
    super.initState();
    loggedUser = Chat().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.targetDisplayName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ChatMessages(
              userUID: loggedUser.uid,
              targetUID: widget.targetUid,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Chat().encryptText(loggedUser.uid, widget.targetUid, _controller.text);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
