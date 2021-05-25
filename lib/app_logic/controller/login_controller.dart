import 'package:chitchat/app_logic/controller/navigation_controller.dart';
import 'package:chitchat/presentation/widgets/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:flutter/material.dart';

class Login {
  final _auth = FirebaseAuth.instance;

  Login({this.context});

  BuildContext context;

  void loginUser(String email, String password) async {
    try {
      final UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user.emailVerified) {
        NavigationScreen().replaceScreen(context, lobbyScreenID);
      } else {
        ShowAlert(
          alertTitle: 'Failed',
          alertContent: 'Login failed.\n$email is not verified\nPlease verify and try again.',
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
