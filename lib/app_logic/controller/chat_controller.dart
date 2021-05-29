import 'dart:async';
import 'package:chitchat/data/set_get_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';

class Chat {
  final _auth = FirebaseAuth.instance;
  User loggedUser;
  encrypt.Key key;
  encrypt.IV iv;

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

  void encryptText(String userUID, String targetUID, String text) {
    final Future<DocumentSnapshot<Map<String, dynamic>>> snapshot = GetData().getUserChatDetail(userUID, targetUID);
    snapshot.then((value) {
      if (!value.exists) {
        key = encrypt.Key.fromSecureRandom(32);
        iv = encrypt.IV.fromSecureRandom(16);
        SetData().setFirstConversationInfo(userUID, targetUID, key.base64, iv.base64);
      } else {
        key = encrypt.Key.fromBase64(value.data()['key']);
        iv = encrypt.IV.fromBase64(value.data()['iv']);
      }
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(text, iv: iv);

      SetData().setEncryptedMessageSender(userUID, targetUID, encrypted.base64);
      if (userUID != targetUID) {
        SetData().setEncryptedMessageReceiver(targetUID, userUID, encrypted.base64);
      }
    });
  }

  String decryptText(String userUID, String targetUID, String encryptedText) {
    final Future<DocumentSnapshot<Map<String, dynamic>>> snapshot = GetData().getUserChatDetail(userUID, targetUID);
    snapshot.then((value) {
      key = encrypt.Key.fromBase64(value.data()['key']);
      iv = encrypt.IV.fromBase64(value.data()['iv']);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
      return decrypted;
    });
  }
}
