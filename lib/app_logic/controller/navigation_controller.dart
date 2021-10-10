import 'package:flutter/material.dart';

class Navigation {
  Navigation();
  Future changeScreen(var context, String route) {
    return Navigator.pushNamed(context, route);
  }

  Future popScreen(var context, String route) async {
    return Navigator.of(context).popUntil((route) => route.isFirst);
    // return Navigator.pushReplacementNamed(context, route);
  }

  Future replaceScreen(var context, String route) async {
    return Navigator.pushReplacementNamed(context, route);
  }
}
