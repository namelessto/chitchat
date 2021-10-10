import 'package:chitchat/app_logic/controller/login_controller.dart';
import 'package:chitchat/presentation/widgets/form_widgets.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //Needed to control the form

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
    FormWidgets formWidgets = new FormWidgets(
        _formKey, context); //Pass _formKey to FormWidget to save state

    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.indigo],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        title: Text(
          'Login',
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
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  formWidgets.buildEmail(_emailController),
                  formWidgets.buildPassword(
                      _pwController1, secureText1, changeSecureText1),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.info,
                          color: Color(0xFF212020),
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
                  formWidgets.buildLoginButton(saveForm),
                  formWidgets.buildResetPasswordButton(),
                  SizedBox(
                    height: 70,
                  ),
                  ElevatedButton.icon(
                    onPressed: Login(context: context).signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.red,
                    ),
                    icon: FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Sign In with Google',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
