import 'package:chitchat/app_logic/controller/lobby_controller.dart';
import 'package:chitchat/data/set_get_db.dart';
import 'package:chitchat/presentation/widgets/chats_list.dart';
import 'package:chitchat/presentation/widgets/search_bar.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key key}) : super(key: key);

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  bool showSpinner = false;

  User loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loggedUser = Lobby().getCurrentUser();
    //print(loggedUser.uid);
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chitchat'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            SetData().updateDeviceTokenLogOut();
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, welcomeScreenID);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, settingScreenID);
            },
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SearchBar(),
                Expanded(
                  child: ChatsList(loggedUser),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
