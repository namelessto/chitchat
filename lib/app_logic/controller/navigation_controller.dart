import 'package:flutter/material.dart';

class Navigation {
  Navigation();
  Future changeScreen(var context, String route) {
    return Navigator.pushNamed(context, route);
  }

  Future replaceScreen(var context, String route) {
    return Navigator.pushReplacementNamed(context, route);
  }
}
