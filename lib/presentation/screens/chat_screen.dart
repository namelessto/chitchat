import 'package:chitchat/app_logic/controller/chat_controller.dart';
import 'package:chitchat/presentation/widgets/chat_messages.dart';
import 'package:chitchat/presentation/widgets/chat_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    this.targetUid,
    this.targetDisplayName,
    this.targetImage,
  });

  final String targetUid;
  final String targetDisplayName;
  final String targetImage;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = new TextEditingController();
  User loggedUser;

  bool isRTL = false;

  @override
  void initState() {
    super.initState();
    loggedUser = Chat().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*iconTheme: IconThemeData(
          color: Colors.black,
        ),*/
        //gradient: gradAppBar,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: widget.targetImage != null
                  ? widget.targetImage != ''
                      ? NetworkImage(widget.targetImage)
                      : AssetImage('assets/profile-pic.png')
                  : AssetImage('assets/profile-pic.png'),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              widget.targetDisplayName,
              /*style: TextStyle(
                color: Colors.black,
              ),*/
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF0EBD8),
            //gradient: gradMain,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ChatMessages(
                userUID: loggedUser.uid,
                targetUID: widget.targetUid,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 6,
                        bottom: 6,
                      ),
                      child: ChatTextField(
                        controller: _controller,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send_rounded),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _controller.text = _controller.text.trim();
                        Chat().encryptText(
                            loggedUser.uid, widget.targetUid, _controller.text);
                      }
                      _controller.clear();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
