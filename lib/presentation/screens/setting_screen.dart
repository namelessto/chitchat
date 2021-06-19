import 'package:chitchat/app_logic/controller/setting_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File profileImage;

  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = FirebaseAuth.instance.currentUser.displayName;
  }

//
  //AssetImage('assets/profile-pic.png')
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await Setting().updateProfile(profileImage, controller.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 100.0,
            backgroundImage: profileImage == null
                ? FirebaseAuth.instance.currentUser.photoURL != null
                    ? NetworkImage(FirebaseAuth.instance.currentUser.photoURL)
                    : AssetImage('assets/profile-pic.png')
                : FileImage(profileImage),
            backgroundColor: Colors.transparent,
          ),
          TextButton(
            onPressed: () async {
              profileImage = await Setting().getImage();
              setState(() {});
            },
            child: Text('Change picture'),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'Change Display Name',
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
