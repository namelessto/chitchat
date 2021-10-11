import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        //gradient: gradAppBar,
        title: Text(
          'Search Result',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFFF0EBD8),
          //gradient: gradMain,
        ),
        child: widget.snapshot.docs.length > 0
            ? ListView.builder(
                itemCount: widget.snapshot.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: widget.snapshot.docs[index]
                                  [colProfileImage] !=
                              null
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
              )
            : Align(
                alignment: Alignment(0, -0.8),
                child: Text(
                  'Couldn\'t find any user..\nTry searching another nickname',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
