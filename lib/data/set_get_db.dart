import 'package:chitchat/data/models/basic_user.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetData {
  void setNewUser(BasicUser user) {
    FirebaseFirestore.instance.collection(colUsers).doc(user.uid()).set({
      'displayName': user.displayName(),
      'email': user.email(),
      'nickname': user.nickname(),
      'uid': user.uid(),
    });
  }
}

class GetData {
  dynamic getUserChatsStreamSnapshots(User user) {
    return FirebaseFirestore.instance.collection(colUsers).doc(user.uid).collection(colChats).snapshots();
  }

  dynamic getUsersStreamSnapshots() {
    return FirebaseFirestore.instance.collection(colUsers).snapshots();
  }
}
