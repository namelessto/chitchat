import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:chitchat/presentation/screens/welcome_screen.dart';
import 'package:chitchat/presentation/screens/registration_screen.dart';
import 'package:chitchat/presentation/screens/login_screen.dart';
import 'package:chitchat/presentation/screens/lobby_screen.dart';
import 'package:chitchat/presentation/screens/chat_screen.dart';

Future<void> main() async {
  String initialRoute;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser != null) {
    initialRoute = lobbyScreenID;
  } else {
    initialRoute = welcomeScreenID;
  }
  runApp(
    Chitchat(
      route: initialRoute,
    ),
  );
}

class Chitchat extends StatelessWidget {
  Chitchat({this.route});
  final String route;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: route,
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
