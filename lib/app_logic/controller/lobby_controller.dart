import 'package:chitchat/data/search_queries.dart';
import 'package:chitchat/data/set_get_db.dart';
import 'package:chitchat/presentation/widgets/chat_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/utilities/constants.dart';

class Lobby {
  final _auth = FirebaseAuth.instance;
  QuerySnapshot<Map<String, dynamic>> snapshot;
  User loggedUser;

  User getCurrentUser() {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        loggedUser = user;
      }
      return loggedUser;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Widget createChatCardFuture(String uid) {
    return FutureBuilder(
      future: DataCollector().queryUserDataUID(uid),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return ChatCard(
              userID: 'Loading..',
              displayName: 'Loading..',
              email: 'Loading..',
              image: null,
            );
          default:
            if (snapshot.hasError)
              return ChatCard(
                userID: 'Error',
                displayName: 'Error',
                email: 'Error',
                image: null,
              );
            else {
              // return ChatCard(
              //   userID: snapshot.data.docs[0][colUID],
              //   displayName: snapshot.data.docs[0][colDisplayName],
              //   email: snapshot.data.docs[0][colEmail],
              // );
              return ChatCard(
                userID: snapshot.data.docs.first.data()[colUID],
                displayName: snapshot.data.docs.first.data()[colDisplayName],
                email: snapshot.data.docs.first.data()[colEmail],
                image: snapshot.data.docs.first.data()[colProfileImage],
              );
            }
        }
      },
    );
  }

  Widget createChatCardStream(String uid) {
    Stream stream = GetData().getUserDataUID(uid);
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return ChatCard(
              userID: 'Loading..',
              displayName: 'Loading..',
              email: 'Loading..',
              image: null,
            );
          default:
            if (snapshot.hasError)
              return ChatCard(
                userID: 'Error',
                displayName: 'Error',
                email: 'Error',
                image: null,
              );
            else {
              return ChatCard(
                userID: snapshot.data[colUID],
                displayName: snapshot.data[colDisplayName],
                email: snapshot.data[colEmail],
                image: snapshot.data[colProfileImage],
              );
            }
        }
      },
    );
  }
}
