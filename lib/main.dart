import 'package:chitchat/presentation/screens/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:chitchat/presentation/screens/welcome_screen.dart';
import 'package:chitchat/presentation/screens/registration_screen.dart';
import 'package:chitchat/presentation/screens/login_screen.dart';
import 'package:chitchat/presentation/screens/lobby_screen.dart';
import 'package:chitchat/presentation/screens/chat_screen.dart';

///Receive message when app is terminated
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification.title);
}

Future<void> main() async {
  String initialRoute;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  ///When app is closed
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
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

class Chitchat extends StatefulWidget {
  Chitchat({this.route});
  final String route;

  @override
  _ChitchatState createState() => _ChitchatState();
}

class _ChitchatState extends State<Chitchat> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();

    ///foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification.body);
        print(message.notification.title);
      }
    });

    ///background but running
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.data["route"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: widget.route,
      routes: {
        welcomeScreenID: (context) => WelcomeScreen(),
        registrationScreenID: (context) => RegistrationScreen(),
        loginScreenID: (context) => LoginScreen(),
        lobbyScreenID: (context) => LobbyScreen(),
        chatScreenID: (context) => ChatScreen(),
        settingScreenID: (context) => SettingsScreen(),
      },
    );
  }
}
