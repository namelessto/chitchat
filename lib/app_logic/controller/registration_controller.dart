import 'package:chitchat/data/models/basic_user.dart';
import 'package:chitchat/data/set_get_db.dart';
import 'package:chitchat/presentation/widgets/alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:flutter/material.dart';

class Registration {
  final _auth = FirebaseAuth.instance;

  Registration({this.context});

  QuerySnapshot<Map<String, dynamic>> nicknameSnapshot;
  Future<bool> futureTrue = Future<bool>.value(true);
  BuildContext context;

  void makeNewUser(String email, String password, String displayName,
      String nickname) async {
    try {
      final UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //newUser.user.updateProfile(displayName: displayName);
      newUser.user.updateDisplayName(displayName);
      newUser.user.sendEmailVerification();
      BasicUser newUserDB = new BasicUser(
        displayName,
        email,
        nickname,
        newUser.user.uid,
      );
      SetData().setNewUser(newUserDB);
      ShowAlert(
        alertTitle: 'Success',
        alertContent:
            'Registration succeeded.\nPlease verify your mail at:\n$email',
        btnText: 'OK',
        onPressed: () {
          Navigator.pushReplacementNamed(context, welcomeScreenID);
        },
      ).showAlert(context).show();
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.code}, email: $email');
      if (e.code == 'email-already-in-use') {
        ShowAlert(
          alertTitle: 'Failed',
          alertContent:
              'Registration failed.\n$email is already in use.\nPlease use another email.',
          btnText: 'OK',
          onPressed: () {
            Navigator.pop(context);
          },
        ).showAlert(context).show();
      }
    }
  }
}
