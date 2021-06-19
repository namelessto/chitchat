import 'dart:collection';
import 'dart:io';
import 'package:chitchat/data/set_get_db.dart';
import 'package:chitchat/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Setting {
  File profileImage;

  final picker = ImagePicker();

  Future<File> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
    }
    print('profile picture type is ${profileImage.runtimeType}');
    return profileImage;
  }

  Future<void> updateProfile(File newProfileImage, String displayName) async {
    String profileImageUrl = '';

    if (newProfileImage != null) {
      profileImageUrl =
          await uploadFile(newProfileImage, 'user/profile/${FirebaseAuth.instance.currentUser.uid}/profile');
    }

    Map<String, Object> data = new HashMap();
    if (profileImageUrl != '') {
      data[colProfileImage] = profileImageUrl;
    }

    data[colDisplayName] = displayName;
    SetData().updateUserProfile(data);
  }

  Future<String> uploadFile(File _image, String path) async {
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref(path);

    firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);

    await uploadTask.whenComplete(() => null);
    String returnURL = '';
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }
}