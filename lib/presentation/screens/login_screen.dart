import 'package:chitchat/presentation/widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); //Needed to control the form

  final TextEditingController _pwController1 = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();

  bool secureText1 = true;
  bool showSpinner = false;
  bool isVisible = false;

  void changeSecureText1() {
    //change visible password in password 1
    setState(() {
      secureText1 = !secureText1;
    });
  }

  void saveForm() {
    if (_formKey.currentState.validate()) {
      setState(() {
        showSpinner = false;
      });
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    FormWidgets formWidgets = new FormWidgets(_formKey, context); //Pass _formKey to FormWidget to save state

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xEEFFFFFF),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  formWidgets.buildEmail(_emailController),
                  formWidgets.buildPassword(_pwController1, secureText1, changeSecureText1),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.info,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),
                      Visibility(
                        visible: isVisible,
                        child: Text(
                          'Reminder: password should contain - \nat least 8 characters, 1 uppercase,\n1 lowercase and 1 number.',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  formWidgets.buildLoginButton(saveForm),
                  SizedBox(
                    height: 15.0,
                  ),
                  formWidgets.buildResetPasswordButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
