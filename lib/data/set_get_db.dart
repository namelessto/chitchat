import 'package:chitchat/data/models/basic_user.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetData {
  final _firestore = FirebaseFirestore.instance;

  void setNewUser(BasicUser user) {
    _firestore.collection(colUsers).doc(user.uid()).set({
      'displayName': user.displayName(),
      'email': user.email(),
      'nickname': user.nickname(),
      'uid': user.uid(),
    });
  }
}

class GetData {
  final _firestore = FirebaseFirestore.instance;

  dynamic getUserChatsStreamSnapshots(User user) {
    return _firestore.collection(colUsers).doc(user.uid).collection(colChats).snapshots();
  }

  dynamic getUsersStreamSnapshots() {
    return _firestore.collection(colUsers).snapshots();
  }

  dynamic getChatMessages(String userUID, String targetUID) {
    return _firestore
        .collection(colUsers)
        .doc(userUID)
        .collection(colChats)
        .doc(targetUID)
        .collection(colMessages)
        .orderBy(colTimeStamp)
        .snapshots();
  }
}
