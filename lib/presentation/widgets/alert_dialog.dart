import 'package:chitchat/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ShowAlert {
  ShowAlert({this.alertTitle, this.alertContent, this.onPressed, this.btnText});

  final String alertTitle;
  final String alertContent;
  final Function onPressed;
  final String btnText;

  Alert showAlert(context) {
    return Alert(
      context: context,
      title: alertTitle,
      desc: alertContent,
      buttons: [
        DialogButton(
          height: 30,
          gradient: gradSecond,
          child: Text(
            btnText,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }

  Alert showAlertTwoButtons(context) {
    return Alert(
      context: context,
      title: alertTitle,
      desc: alertContent,
      buttons: [
        DialogButton(
          height: 30,
          gradient: gradSecond,
          child: Text(
            btnText,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: onPressed,
        ),
        DialogButton(
          height: 30,
          gradient: gradSecond,
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
