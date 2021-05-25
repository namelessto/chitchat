import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataCollector {
  Future queryUsersDataNickname1(String queryString) async {
    return FirebaseFirestore.instance.collection(colUsers).where(colNickname, isEqualTo: queryString).get();
  }

  Future queryUsersDataNickname2(String queryString) async {
    return FirebaseFirestore.instance
        .collection(colUsers)
        .where(colNickname, isGreaterThanOrEqualTo: queryString)
        .get();
  }

  Future queryUserDataUID(String queryString) async {
    return FirebaseFirestore.instance.collection(colUsers).where(colUID, isEqualTo: queryString).get();
  }

  Future queryChatsData(String queryString, String uid) async {
    return FirebaseFirestore.instance.collection(colUsers).doc(uid).collection(colChats).get();
  }
}
