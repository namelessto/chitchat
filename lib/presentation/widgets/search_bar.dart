import 'package:chitchat/data/search_queries.dart';
import 'package:chitchat/presentation/screens/search_result_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/utilities/constants.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = new TextEditingController();

  QuerySnapshot<Map<String, dynamic>> snapshot;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      controller: _controller,
      decoration: textFieldDecoration.copyWith(
        prefixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _controller.clear();
            });
          },
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            snapshot = await DataCollector().queryUsersDataNickname2(_controller.text);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResult(
                    snapshot,
                  ),
                ));
          },
        ),
      ),
    );
  }
}
