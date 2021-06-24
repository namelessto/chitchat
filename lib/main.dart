import 'package:chitchat/app_logic/controller/fcm_controller.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print('message title: ${message.notification.title}');
  //print('tid: ${message.data}');

  //navigatorKey.currentState.push();
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> main() async {
  String initialRoute;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

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
    PushNotificationService().getToken();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.push(
        navigatorKey.currentState.context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            targetUid: message.data[colTID],
            targetDisplayName: message.data[colDisplayName],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
