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
          child: Text(btnText),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
