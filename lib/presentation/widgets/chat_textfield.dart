import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/cupertino.dart';
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
    return AutoDirection(
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
            str = str.trimLeft();
          });
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 8, right: 8, top: 12),
          isDense: true,
          filled: true,
          focusColor: Colors.white,
          fillColor: Colors.white,
          hintText: 'Type your message here',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      ),
    );
  }
}
