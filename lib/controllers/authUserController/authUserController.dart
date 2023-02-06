import 'dart:io';

import 'package:bug_tracker/controllers/fetchAllUsers/fetchAllUsersController.dart';
import 'package:bug_tracker/models/currUserData/currUserData.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthUserController extends GetxController {
  final FetchAllUsers allUserFetchController = Get.put(FetchAllUsers());

  final _auth = FirebaseAuth.instance;
  RxBool isLoadingAuth = false.obs;

  Future<void> authUser(String email, String username, String password,
      bool isLogin, XFile? image) async {
    UserCredential userCredential;

    try {
      isLoadingAuth.value = true;

      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

      if (userCredential.user == null) {
        throw Dialogs.GENERIC_ERROR_MESSAGE;
      }

      if (!isLogin) {
        final refPath = FirebaseStorage.instance
            .ref()
            .child('user-image')
            .child("${userCredential.user!.uid} + .jpg");

        await refPath.putFile(
          File(image!.path),
        );

        final dpUrl = await refPath.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'username': username,
            'email': email,
            'dpUrl': dpUrl,
          },
        );

        await allUserFetchController.fetchAllUsers();
        //new users signed up so update all users list
      }

      isLoadingAuth.value = false;
    } on FirebaseAuthException catch (error) {
      isLoadingAuth.value = false;
      if (error.code == 'email-already-in-use') {
        throw Dialogs.EMAIL_EXISTS;
      }
      if (error.code == 'invalid-email' ||
          error.code == 'invalid-email-verified') {
        throw Dialogs.INVALID_EMAIL;
      }
      if (error.code == 'user-not-found') {
        throw Dialogs.USER_NOT_FOUND;
      }
      if (error.code == 'wrong-password') {
        throw Dialogs.INCORRECT_PASSWORD;
      }
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    } catch (error) {
      isLoadingAuth.value = false;
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    }
  }

  Future<void> logOut() async {
    _auth.signOut();
    allUserFetchController.currentUserData = [
      UserData('', ''),
    ];
  }
}
