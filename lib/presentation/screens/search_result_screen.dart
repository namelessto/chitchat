import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  SearchResult(this.snapshot);

  final QuerySnapshot<Map<String, dynamic>> snapshot;

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: widget.snapshot.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(),
            title: Text(widget.snapshot.docs[index].data()[colDisplayName]),
            onTap: () {
              //TODO: implement go to chat
            },
          );
        },
      ),
    );
  }
}
