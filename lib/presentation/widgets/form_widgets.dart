import 'package:chitchat/app_logic/controller/login_controller.dart';
import 'package:chitchat/app_logic/controller/registration_controller.dart';
import 'package:chitchat/data/search_queries.dart';
import 'package:chitchat/presentation/widgets/rounded_button.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'alert_dialog.dart';

class FormWidgets {
  FormWidgets(this._formKey, this.context);

  GlobalKey<FormState> _formKey;
  BuildContext context;

  QuerySnapshot<Map<String, dynamic>> snapshot;

  TextEditingController emailController = new TextEditingController();

  String _displayName;
  String _email;
  String _nickname;
  String _password1;
  String _password2;

  bool taken = false;

  Widget buildDisplayName() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.name,
        enableSuggestions: true,
        autocorrect: true,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Name is required';
          }
          return null;
        },
        onSaved: (String value) => _displayName = value,
        decoration: textFieldDecoration.copyWith(
          hintText: 'The name that will be shown in chat',
          labelText: 'Display Name',
        ),
      ),
    );
  }

  Widget buildEmail(TextEditingController _emailController) {
    emailController = _emailController;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: TextFormField(
        controller: emailController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        enableSuggestions: true,
        autocorrect: true,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Email is required';
          }
          if (!RegExp(emailRegex).hasMatch(value)) {
            return 'Enter a valid email address';
          }
          return null;
        },
        onSaved: (String value) {
          _email = value;
        },
        decoration: textFieldDecoration.copyWith(
          hintText: 'Enter your email',
          labelText: 'Email',
        ),
      ),
    );
  }

  Widget buildNickname() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.text,
        enableSuggestions: true,
        autocorrect: true,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Nickname is required';
          }
          if (!RegExp(nicknameRegex).hasMatch(value)) {
            return 'Can\'t contain space';
          }
          DataCollector().queryUsersDataNickname1(value).then((valueSnapshot) {
            snapshot = valueSnapshot;
            try {
              if (snapshot.docs.isNotEmpty) {
                _nickname = snapshot.docs.first.data()[colNickname];
                taken = true;
              } else {
                taken = false;
              }
            } catch (e) {
              print(e);
            }
          });
          if (taken) {
            return '$_nickname is taken';
          }
          return null;
        },
        onSaved: (String value) {
          _nickname = value;
        },
        decoration: textFieldDecoration.copyWith(
          hintText: 'Enter a nickname',
          labelText: 'Nickname',
        ),
      ),
    );
  }

  Widget buildPassword(
    TextEditingController _passwordController1,
    bool secureText1,
    Function onPressed,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: TextFormField(
        controller: _passwordController1,
        keyboardType: TextInputType.visiblePassword,
        obscureText: secureText1,
        enableSuggestions: false,
        autocorrect: false,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is required';
          }
          if (!RegExp(passwordRegex).hasMatch(value)) {
            _passwordController1.clear();
            return 'Enter a valid password';
          }
          return null;
        },
        onSaved: (String value) {
          _password1 = value;
        },
        decoration: textFieldDecoration.copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              secureText1 ? Icons.remove_red_eye_outlined : Icons.security,
              color: Colors.grey,
            ),
            onPressed: onPressed,
          ),
          // hintText: '8 chars, 1 Capital, 1 Lowercase, 1 Number.',
          // hintStyle: TextStyle(
          //   fontSize: 14.0,
          // ),
          labelText: 'Password',
        ),
      ),
    );
  }

  Widget buildConfirmPassword(
    TextEditingController _pwController1,
    TextEditingController _pwController2,
    bool secureText2,
    Function onPressed,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: TextFormField(
        controller: _pwController2,
        keyboardType: TextInputType.visiblePassword,
        obscureText: secureText2,
        enableSuggestions: false,
        autocorrect: false,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is required';
          }
          if (!RegExp(passwordRegex).hasMatch(value)) {
            _pwController2.clear();
            return 'Enter a valid password';
          }
          if (value != _pwController1.text) {
            _pwController2.clear();
            return 'Password don\'t match.';
          }
          return null;
        },
        onSaved: (String value) {
          _password2 = value;
        },
        decoration: textFieldDecoration.copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              secureText2 ? Icons.remove_red_eye_outlined : Icons.security,
              color: Colors.grey,
            ),
            onPressed: onPressed,
          ),
          // hintText: '8 chars, 1 Capital, 1 Lowercase, 1 Number.',
          // hintStyle: TextStyle(
          //   fontSize: 14.0,
          // ),
          labelText: 'Confirm Password',
        ),
      ),
    );
  }

  Widget buildSubmitButton(Function onPress) {
    return RoundedButton(
      onPress: () {
        onPress();
        Registration registration = new Registration(context: context);
        registration.makeNewUser(_email, _password1, _displayName, _nickname);
      },
      text: 'Submit',
    );
  }

  Widget buildLoginButton(Function onPress) {
    return RoundedButton(
      onPress: () {
        onPress();
        Login login = new Login(context: context);
        login.loginUser(_email, _password1);
      },
      text: 'Login',
    );
  }

  Widget buildResetPasswordButton() {
    return TextButton(
      onPressed: () {
        try {
          _email = emailController.text;
          if (_email != '') {
            if (RegExp(emailRegex).hasMatch(_email)) {
              Login(context: context).sendResetPassword(_email);
            } else {
              ShowAlert(
                alertTitle: 'Reset Request',
                alertContent: 'Please enter a valid email',
                btnText: 'OK',
                onPressed: () {
                  Navigator.pop(context);
                },
              ).showAlert(context).show();
            }
          } else {
            ShowAlert(
              alertTitle: 'Reset Request',
              alertContent: 'Please enter email',
              btnText: 'OK',
              onPressed: () {
                Navigator.pop(context);
              },
            ).showAlert(context).show();
          }
        } catch (e) {
          print('Something went wrong + $e');
        }
      },
      child: Text('Reset Password?'),
    );
  }

  void sendResetPassword(Function onPress) {}
}
