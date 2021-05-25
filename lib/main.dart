import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:chitchat/presentation/screens/welcome_screen.dart';
import 'package:chitchat/presentation/screens/registration_screen.dart';
import 'package:chitchat/presentation/screens/login_screen.dart';
import 'package:chitchat/presentation/screens/lobby_screen.dart';
import 'package:chitchat/presentation/screens/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Chitchat());
}

class Chitchat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: welcomeScreenID,
      routes: {
        welcomeScreenID: (context) => WelcomeScreen(),
        registrationScreenID: (context) => RegistrationScreen(),
        loginScreenID: (context) => LoginScreen(),
        lobbyScreenID: (context) => LobbyScreen(),
        chatScreenID: (context) => ChatScreen(),
      },
    );
  }
}
