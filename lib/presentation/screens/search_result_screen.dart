import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class SearchResult extends StatefulWidget {
  SearchResult(this.snapshot);

  final QuerySnapshot snapshot;

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: gradAppBar,
        title: Text('Search Result'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: gradMain,
        ),
        child: ListView.builder(
          itemCount: widget.snapshot.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    widget.snapshot.docs[index][colProfileImage] != null
                        ? widget.snapshot.docs[index][colProfileImage] != ''
                            ? NetworkImage(
                                widget.snapshot.docs[index][colProfileImage])
                            : AssetImage('assets/profile-pic.png')
                        : AssetImage('assets/profile-pic.png'),
              ),
              title: Text(widget.snapshot.docs[index][colDisplayName]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      targetUid: widget.snapshot.docs[index][colUID],
                      targetDisplayName: widget.snapshot.docs[index]
                          [colDisplayName],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
