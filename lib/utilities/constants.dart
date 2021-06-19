import 'package:flutter/material.dart';

// ---------- Routes ----------
const String welcomeScreenID = 'welcome_screen';
const String registrationScreenID = 'registration_screen';
const String loginScreenID = 'login_screen';
const String lobbyScreenID = 'lobby_screen';
const String chatScreenID = 'chat_screen';
const String searchResultID = 'search_result_screen';
const String settingScreenID = 'setting_screen';

// ---------- Regex ----------
const String emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$";
const String passwordRegex = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
const String nicknameRegex = r'^[^\s]*$';

// ---------- TextFormField Decorations ----------
const textFieldDecoration = InputDecoration(
  hintStyle: TextStyle(
    fontSize: 15.0,
  ),
  filled: true,
  fillColor: Colors.white,
  focusColor: Colors.white,
  labelStyle: TextStyle(
    fontSize: 25.0,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);

// ---------- Collections Paths ----------
String colMessages = 'messages';
String colUsers = 'users';
String colChats = 'chats';
String colText = 'text';
String colEmail = 'email';
String colDisplayName = 'displayName';
String colUID = 'userID';
String colTID = 'targetID';
String colTimeStamp = 'timeStamp';
String colNickname = 'nickname';
String colLastMessageSent = 'lastMessageSent';
String colEncryptedText = 'encryptedText';
String colKey = 'key';
String colIV = 'iv';
String colProfileImage = 'profileImage';
