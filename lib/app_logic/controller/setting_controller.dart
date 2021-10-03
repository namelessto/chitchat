import 'dart:collection';
import 'dart:io';
import 'package:chitchat/data/set_get_db.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';

class Setting {
  File profileImage;
  final picker = ImagePicker();

  Future<File> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
    }
    return profileImage;
  }

  Future<void> updateProfile(File newProfileImage, String displayName) async {
    String profileImageUrl = '';

    if (newProfileImage != null) {
      profileImageUrl = await uploadFile(newProfileImage,
          'user/profile/${FirebaseAuth.instance.currentUser.uid}/profile');
    }

    Map<String, Object> data = new HashMap();
    if (profileImageUrl != '') {
      data[colProfileImage] = profileImageUrl;
    }
    if (displayName != '') {
      data[colDisplayName] = displayName;
    }
    SetData().updateUserProfile(data);
  }

  Future<String> uploadFile(File _image, String path) async {
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref(path);

    firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);

    await uploadTask.whenComplete(() => null);
    String returnURL = '';
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  Future<void> deleteImage() async {
    try {
      String path =
          'user/profile/${FirebaseAuth.instance.currentUser.uid}/profile';
      firebase_storage.FirebaseStorage.instance.ref(path).delete();
      SetData().deleteUserProfile();
    } catch (error) {
      print(error);
    }
  }

  dynamic getPermissionForStorage() async {
    PermissionStatus status = await Permission.storage.status;
    //print('status is $status');
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    return status;
  }
}
