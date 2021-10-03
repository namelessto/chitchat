import 'package:chitchat/app_logic/controller/fcm_controller.dart';
import 'package:chitchat/data/models/basic_user.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetData {
  final _firestore = FirebaseFirestore.instance;

  void setNewUser(BasicUser user) {
    _firestore.collection(colUsers).doc(user.uid()).set({
      colDisplayName: user.displayName(),
      colEmail: user.email(),
      colNickname: user.nickname(),
      colUID: user.uid(),
      colProfileImage: '',
      colDeviceToken: '',
    });
  }

  void setFirstConversationInfo(
      String userUID, String targetUID, String key, String iv) {
    _firestore
        .collection(colUsers)
        .doc(userUID)
        .collection(colChats)
        .doc(targetUID)
        .set({
      colUID: userUID,
      colTID: targetUID,
      colKey: key,
      colIV: iv,
      colLastMessageSent: FieldValue.serverTimestamp(),
    });
  }

  void setFirstConversationInfoReceiver(
      String userUID, String targetUID, String key, String iv) {
    _firestore
        .collection(colUsers)
        .doc(userUID)
        .collection(colChats)
        .doc(targetUID)
        .set({
      colUID: userUID,
      colTID: targetUID,
      colKey: key,
      colIV: iv,
      colLastMessageSent: FieldValue.serverTimestamp(),
    });
  }

  void updateConversationInfo(String userUID, String targetUID) {
    _firestore
        .collection(colUsers)
        .doc(userUID)
        .collection(colChats)
        .doc(targetUID)
        .update({
      colLastMessageSent: FieldValue.serverTimestamp(),
    });
  }

  void setEncryptedMessageSender(
      String userUID, String targetUID, String encryptedText) {
    _firestore
        .collection(colUsers)
        .doc(userUID)
        .collection(colChats)
        .doc(targetUID)
        .collection(colMessages)
        .add({
      colUID: userUID,
      colTID: targetUID,
      colEncryptedText: encryptedText,
      colTimeStamp: FieldValue.serverTimestamp(),
      colSentNotification: false,
    });
  }

  void setEncryptedMessageReceiver(
      String userUID, String targetUID, String encryptedText) {
    _firestore
        .collection(colUsers)
        .doc(userUID)
        .collection(colChats)
        .doc(targetUID)
        .collection(colMessages)
        .add({
      colUID: targetUID,
      colTID: userUID,
      colEncryptedText: encryptedText,
      colTimeStamp: FieldValue.serverTimestamp(),
    });
  }

  void updateUserProfile(Map<String, Object> data) {
    if (data[colDisplayName] != null) {
      _firestore
          .collection(colUsers)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update(data);
      FirebaseAuth.instance.currentUser.updatePhotoURL(data[colProfileImage]);
      FirebaseAuth.instance.currentUser.updateDisplayName(data[colDisplayName]);
    }
  }

  void deleteUserProfile() {
    _firestore
        .collection(colUsers)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({colProfileImage: ''});
    FirebaseAuth.instance.currentUser.updatePhotoURL(null);
  }

  void updateUserDeviceToken() async {
    _firestore
        .collection(colUsers)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      colDeviceToken: await PushNotificationService().getToken(),
    });
  }

  void updateDeviceTokenLogOut() async {
    _firestore
        .collection(colUsers)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      colDeviceToken: '',
    });
  }
}

class GetData {
  final _firestore = FirebaseFirestore.instance;

  dynamic getUserChatsStreamSnapshots(String userUID) {
    return _firestore
        .collection(colUsers)
        .doc(userUID)
        .collection(colChats)
        .orderBy(
          colLastMessageSent,
          descending: true,
        )
        .snapshots();
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

  dynamic getUserChatDetail(String userUID, String targetUID) {
    return _firestore
        .collection(colUsers)
        .doc(userUID)
        .collection(colChats)
        .doc(targetUID)
        .get();
  }

  dynamic getUserChatDetail2(String userUID, String targetUID) {
    return _firestore
        .collection(colUsers)
        .doc(userUID)
        .collection(colChats)
        .doc(targetUID)
        .snapshots();
  }

  dynamic getUserDataUID(String userUID) {
    return _firestore.collection(colUsers).doc(userUID).snapshots();
  }
}
