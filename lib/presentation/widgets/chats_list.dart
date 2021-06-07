import 'package:chitchat/app_logic/controller/lobby_controller.dart';
import 'package:chitchat/data/set_get_db.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsList extends StatefulWidget {
  ChatsList(this.user);

  final User user;

  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  QuerySnapshot<Map<String, dynamic>> userSnapshot;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: GetData().getUserChatsStreamSnapshots(widget.user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
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
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return Lobby().createChatCard(snapshot.data.docs[index][colTID]);
            },
          );
        }
      },
    );
  }
}
