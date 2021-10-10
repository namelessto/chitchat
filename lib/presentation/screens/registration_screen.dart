import 'package:flutter/material.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:chitchat/presentation/widgets/form_widgets.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //Needed to control the form

  final TextEditingController _pwController1 = new TextEditingController();
  final TextEditingController _pwController2 = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();

  bool secureText1 = true;
  bool secureText2 = true;

  void changeSecureText1() {
    //change visible password in password 1
    setState(() {
      secureText1 = !secureText1;
    });
  }

  void changeSecureText2() {
    //change visible password in password 2
    setState(() {
      secureText2 = !secureText2;
    });
  }

  void saveForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    FormWidgets formWidgets = new FormWidgets(
        _formKey, context); //Pass _formKey to FormWidget to save state
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: gradAppBar,
        title: Text(
          'Register',
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: gradMain,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  formWidgets.buildDisplayName(),
                  formWidgets.buildEmail(_emailController),
                  formWidgets.buildNickname(),
                  formWidgets.buildPassword(
                    _pwController1,
                    secureText1,
                    changeSecureText1,
                  ),
                  Text(
                    'Password must contain at least 8 characters, 1 uppercase, 1 lowercase and 1 number.',
                  ),
                  formWidgets.buildConfirmPassword(
                    _pwController1,
                    _pwController2,
                    secureText2,
                    changeSecureText2,
                  ),
                  formWidgets.buildSubmitButton(
                    saveForm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
