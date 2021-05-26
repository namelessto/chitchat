import 'package:firebase_auth/firebase_auth.dart';

class Chat {
  final _auth = FirebaseAuth.instance;
  User loggedUser;

  User getCurrentUser() {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        loggedUser = user;
      }
      return loggedUser;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
