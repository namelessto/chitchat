import 'package:chitchat/app_logic/controller/navigation_controller.dart';
import 'package:chitchat/data/models/basic_user.dart';
import 'package:chitchat/data/search_queries.dart';
import 'package:chitchat/data/set_get_db.dart';
import 'package:chitchat/presentation/widgets/alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login {
  final _auth = FirebaseAuth.instance;

  Login({this.context});

  BuildContext context;

  void signInWithGoogle() async {
    QuerySnapshot<Map<String, dynamic>> snapshot;
    String googleUID;
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await _auth.signInWithCredential(credential);

    try {
      snapshot = await DataCollector().queryUserDataUID(_auth.currentUser.uid);
      googleUID = snapshot.docs[0].data()[colUID];
    } catch (e) {
      print(e);
      googleUID = '';
      snapshot = null;
    }

    if (googleUID == _auth.currentUser.uid) {
      print("GoogleUID = " + googleUID);
      SetData().updateUserDeviceToken();
      Navigation().popScreen(context, lobbyScreenID);
      Navigation().replaceScreen(context, lobbyScreenID);
    } else {
      createNickname().then((value) {
        BasicUser newGoogleUser = new BasicUser(_auth.currentUser.displayName,
            _auth.currentUser.email, value, _auth.currentUser.uid);
        SetData().setNewUser(newGoogleUser);
        Navigation().popScreen(context, lobbyScreenID);
        Navigation().replaceScreen(context, lobbyScreenID);
      });
    }
  }

  Future<String> createNickname() async {
    TextEditingController nicknameInput = new TextEditingController();
    QuerySnapshot<Map<String, dynamic>> snapshot;
    String nickname;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Choose a nickname:'),
            content: TextField(
              controller: nicknameInput,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    snapshot = await DataCollector()
                        .queryUsersDataNickname1(nicknameInput.text);
                    nickname = snapshot.docs[0].data()[colNickname];
                  } catch (e) {
                    print(e);
                    snapshot = null;
                  }
                  if (snapshot != null) {
                    if (nickname != null) {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text('Nickname already in use'),
                              children: [
                                Center(
                                  child: Text('Please choose another.'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          });
                    }
                  } else {
                    Navigator.of(context).pop(nicknameInput.text);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          );
        });
  }

  void loginUser(String email, String password) async {
    try {
      final UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user.emailVerified) {
        SetData().updateUserDeviceToken();
        Navigation().popScreen(context, lobbyScreenID);
        Navigation().replaceScreen(context, lobbyScreenID);
      } else {
        ShowAlert(
          alertTitle: 'Failed',
          alertContent:
              'Login failed.\n$email is not verified\nPlease verify and try again.',
          btnText: 'OK',
          onPressed: () {
            Navigator.pop(context);
          },
        ).showAlert(context).show();
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        ShowAlert(
          alertTitle: 'Oops',
          alertContent: 'User doesn\'t exist.',
          btnText: 'OK',
          onPressed: () {
            Navigator.pop(context);
          },
        ).showAlert(context).show();
      }
      if (e.code == 'wrong-password') {
        ShowAlert(
          alertTitle: 'Oops',
          alertContent: 'Wrong email or password',
          btnText: 'OK',
          onPressed: () {
            Navigator.pop(context);
          },
        ).showAlert(context).show();
      }
    }
  }

  void sendResetPassword(String email) {
    try {
      _auth.sendPasswordResetEmail(email: email);
      ShowAlert(
        alertTitle: 'Reset Request Sent',
        alertContent: '$email will receive a request to reset password',
        btnText: 'OK',
        onPressed: () {
          Navigator.pop(context);
        },
      ).showAlert(context).show();
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }
}
