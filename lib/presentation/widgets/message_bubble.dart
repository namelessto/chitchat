import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    this.displayName,
    this.senderEmail,
    this.text,
    this.isMe,
    this.textWidget,
  });

  final String displayName;
  final String senderEmail;
  final String text;
  final bool isMe;

  final Widget textWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 30.0 : 10.0),
              topRight: Radius.circular(isMe ? 10.0 : 30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 3.0,
            color: isMe ? Color(0xFFB2BCC2) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 13,
              ),
              child: textWidget,
            ),
          ),
        ],
      ),
    );
  }
}
