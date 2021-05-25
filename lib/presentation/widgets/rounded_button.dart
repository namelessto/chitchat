import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    //@required this.color,
    @required this.onPress,
    @required this.text,
  });

  //final Color color;
  final Function onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        //color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 45.0,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
