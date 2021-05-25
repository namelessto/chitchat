import 'package:chitchat/app_logic/controller/lobby_controller.dart';
import 'package:chitchat/data/search_queries.dart';
import 'package:chitchat/presentation/widgets/chat_card.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  SearchResult(this.snapshot);

  final QuerySnapshot snapshot;

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Result'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.snapshot.docs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(),
            title: Text(widget.snapshot.docs[index][colDisplayName]),
            onTap: () {
              //TODO: Implement enter to chat
            },
          );
        },
      ),
    );
  }
}
