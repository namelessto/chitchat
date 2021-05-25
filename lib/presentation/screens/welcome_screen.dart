import 'package:chitchat/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/presentation/widgets/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chitchat/app_logic/controller/navigation_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 150.0,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  FlickerAnimatedText(
                    'CHITCHAT',
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontSize: 75.0,
                    ),
                  ),
                ],
              ),
            ),
            RoundedButton(
              onPress: () => NavigationScreen().changeScreen(context, loginScreenID),
              text: 'Login',
            ),
            RoundedButton(
              onPress: () => NavigationScreen().changeScreen(context, registrationScreenID),
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
