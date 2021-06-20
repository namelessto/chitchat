import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  ChatTextField({this.controller});
  final TextEditingController controller;

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  bool isRTL = false;
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        top: 5,
        bottom: 5,
        right: 10,
      ),
      child: AutoDirection(
        onDirectionChange: (isRTL) {
          setState(() {
            this.isRTL = isRTL;
          });
        },
        text: text,
        child: TextField(
          controller: widget.controller,
          maxLines: 5,
          minLines: 1,
          onChanged: (str) {
            setState(() {
              text = str;
            });
          },
          decoration: InputDecoration(
            hintText: 'Type your message here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
          ),
        ),
      ),
    );
  }
}
