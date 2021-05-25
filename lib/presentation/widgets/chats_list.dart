import 'dart:async';

import 'package:chitchat/app_logic/controller/lobby_controller.dart';
import 'package:chitchat/data/search_queries.dart';
import 'package:chitchat/data/set_get_db.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_card.dart';

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
      stream: GetData().getUserChatsStreamSnapshots(widget.user),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('Couldn\'t find data');
          return CircularProgressIndicator();
        } else {
          if (snapshot.connectionState == ConnectionState.waiting) {
            Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              QuerySnapshot<Map<String, dynamic>> tempSnapshot;
              return Lobby().createChatCard(snapshot.data.docs[index][colUID]);
            },
          );

          //
          // return ListView(
          //   scrollDirection: Axis.vertical,
          //   shrinkWrap: true,
          //   children: chatCards,
          // );
        }
      },
    );
  }
}
