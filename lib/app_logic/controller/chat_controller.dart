import 'dart:async';
import 'package:auto_direction/auto_direction.dart';
import 'package:chitchat/data/set_get_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        if (userUID != targetUID) {
          SetData().setFirstConversationInfoReceiver(targetUID, userUID, key.base64, iv.base64);
        }
      } else {
        key = encrypt.Key.fromBase64(value.data()['key']);
        iv = encrypt.IV.fromBase64(value.data()['iv']);
        SetData().updateConversationInfo(userUID, targetUID);
        SetData().updateConversationInfo(targetUID, userUID);
      }
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final encrypted = encrypter.encrypt(text, iv: iv);

      SetData().setEncryptedMessageSender(userUID, targetUID, encrypted.base64);
      if (userUID != targetUID) {
        SetData().setEncryptedMessageReceiver(targetUID, userUID, encrypted.base64);
      }
    });
  }

  Widget decryptText(String userUID, String targetUID, String encryptedText) {
    Future<DocumentSnapshot<Map<String, dynamic>>> documentFuture = GetData().getUserChatDetail(userUID, targetUID);

    return FutureBuilder(
      future: documentFuture,
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading..');
          default:
            if (snapshot.hasError)
              return Text('Error');
            else {
              key = encrypt.Key.fromBase64(snapshot.data['key']);
              iv = encrypt.IV.fromBase64(snapshot.data['iv']);

              final encrypter = encrypt.Encrypter(encrypt.AES(key));
              final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
              return GestureDetector(
                  onLongPress: () => Clipboard.setData(
                        ClipboardData(
                          text: decrypted,
                        ),
                      ).then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Message copied to clipboard'),
                          ),
                        ),
                      ),
                  child: Text(decrypted));
            }
        }
      },
    );
  }

  Widget decryptText2(String userUID, String targetUID, String encryptedText) {
    Stream stream = GetData().getUserChatDetail2(userUID, targetUID);

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading..');
          default:
            if (snapshot.hasError)
              return Text('Error');
            else {
              key = encrypt.Key.fromBase64(snapshot.data['key']);
              iv = encrypt.IV.fromBase64(snapshot.data['iv']);

              final encrypter = encrypt.Encrypter(encrypt.AES(key));
              final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
              return GestureDetector(
                onLongPress: () => Clipboard.setData(
                  ClipboardData(
                    text: decrypted,
                  ),
                ).then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Message copied to clipboard'),
                    ),
                  ),
                ),
                child: AutoDirection(
                  text: decrypted,
                  child: Text(decrypted),
                ),
              );
            }
        }
      },
    );
  }
}
