import 'dart:io';
import 'package:chitchat/app_logic/controller/setting_controller.dart';
import 'package:chitchat/presentation/widgets/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String profileImagePath;
  File profileImage;
  ImageProvider currentImage;
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = FirebaseAuth.instance.currentUser.displayName;
    profileImagePath = FirebaseAuth.instance.currentUser.photoURL;
    //chooseImage(profileImage);
  }

  @override
  Widget build(BuildContext context) {
    chooseImage(profileImage);
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await Setting().updateProfile(profileImage, controller.text);
              ShowAlert(
                alertTitle: 'Success',
                alertContent: 'Info updated.',
                btnText: 'OK',
                onPressed: () {
                  Navigator.pop(context);
                },
              ).showAlert(context).show();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 100.0,
            backgroundImage: currentImage,
            backgroundColor: Colors.transparent,
          ),
          TextButton(
            onPressed: () async {
              PermissionStatus status =
                  await Setting().getPermissionForStorage();
              if (status.isGranted) {
                profileImage = await Setting().getImage();
              }
              setState(() {});
            },
            child: Text('Change picture'),
          ),
          TextButton(
            onPressed: () {
              if (currentImage != AssetImage('assets/profile-pic.png')) {
                ShowAlert(
                    alertTitle: 'Delete Your Profile Picture',
                    alertContent:
                        'Are you sure you want to delete your profile picture?',
                    btnText: 'Delete',
                    onPressed: () async {
                      setState(() {
                        profileImage = null;
                      });
                      Setting().deleteImage();
                      Navigator.pop(context);
                    }).showAlertTwoButtons(context).show();
              } else {
                ShowAlert(
                    alertTitle: 'No Profile Picture',
                    alertContent: 'No profile image was found',
                    btnText: 'OK',
                    onPressed: () {
                      Navigator.pop(context);
                      //setState(() {});
                    }).showAlert(context).show();
              }
            },
            child: Text('Delete picture'),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Change Display Name',
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void chooseImage(File image) {
    currentImage = image == null
        ? profileImagePath == null
            ? AssetImage('assets/profile-pic.png')
            : NetworkImage(profileImagePath)
        : FileImage(image);
  }
}
