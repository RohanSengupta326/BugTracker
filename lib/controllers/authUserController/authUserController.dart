import 'dart:io';
import 'dart:math';
import 'dart:developer' as developer;

import 'package:bug_tracker/models/currUserData/currUserData.dart';
import 'package:bug_tracker/models/usersDetails/usersDetails.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../projectController/projectController.dart';

class AuthUserController extends GetxController {
  bool didUserSignIn = false;
  // to check if user signed in or already signed in, based on that different way data will be loaded in homepage initstate.
  final ProjectsController projectsController = Get.put(ProjectsController());

  final _auth = FirebaseAuth.instance;
  RxBool isLoadingAuth = false.obs;

  List<UsersDetails> _users = [];
  List<UserData> currentUserData = [
    UserData('', ''),
  ];

  RxBool isUserFetching = false.obs;
  RxBool isLoadingUserData = false.obs;
  RxBool isSaveUserDataLoading = false.obs;
  RxBool isGoogleLoadingAuth = false.obs;

  List<UsersDetails> get users {
    return [..._users];
  }

  Future<void> authUser(String email, String username, String password,
      bool isLogin, XFile? image) async {
    UserCredential userCredential;

    try {
      didUserSignIn = true;
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
          SettableMetadata(contentEncoding: 'identity'),
          // doesnt compress image , so quality is maintained
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
      }
      await fetchAllUsers();
      await fetchUserData();
      await projectsController.fetchProject();
      //new users signed up so update all users list

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

  Future<void> googleUserSignUp() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    UserCredential userCredential;

    try {
      didUserSignIn = true;
      isGoogleLoadingAuth.value = true;

      // interactive page pops up
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // authenticate user
      final GoogleSignInAuthentication googleUserAuthentication =
          await googleUser!.authentication;

      // get user credentials
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleUserAuthentication.accessToken,
        idToken: googleUserAuthentication.idToken,
      );

      // login / sign up with firebase into the app
      userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Dialogs.GENERIC_ERROR_MESSAGE;
      }

      // check if user already exists
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!user.exists) {
        // print('--NEW USER--');
        // if logging in then no need to save image and name
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(
          {
            'username': googleUser.displayName ?? '',
            'email': googleUser.email,
            'dpUrl': googleUser.photoUrl ?? '',
          },
        );
      }
      print('########## USER SIGN-IN DONE ##########');
      await fetchAllUsers();
      await fetchUserData();
      await projectsController.fetchProject();
      //new users signed up so update all users list

      isGoogleLoadingAuth.value = false;
    } catch (error) {
      print(error.toString());
      isGoogleLoadingAuth.value = false;
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    }
  }

  Future<void> logOut() async {
    didUserSignIn = false;
    _auth.signOut();
    currentUserData = [
      UserData('', ''),
    ];
    await GoogleSignIn()
        .disconnect(); // lets user choose mail again, before signing up
  }

  Future<void> fetchAllUsers() async {
    _users = [];

    try {
      isUserFetching.value = true;

      final allUsers =
          await FirebaseFirestore.instance.collection('users').get();

      for (var i = 0; i < allUsers.docs.length; i++) {
        _users.add(
          UsersDetails(
            allUsers.docs[i].data()['username'],
            allUsers.docs[i].data()['email'],
          ),
        );
      }

      isUserFetching.value = false;
      // print('--------FETCHED ALL USERS--------');
    } catch (error) {
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    }
  }

  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // print('######## $userId #######\n');

    try {
      isLoadingUserData.value = true;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // print('------------ ${userData['username']} ----------\n');
      // print('------------ ${userData['dpUrl']} ----------\n');

      currentUserData = [
        UserData(
          userData['username'] ?? '',
          userData['dpUrl'],
        ),
      ];

      // print('------------ ${currentUserData[0].dpUrl} ----------');
      // print('------------ ${currentUserData[0].username} ----------');

      isLoadingUserData.value = false;
    } catch (err) {
      isLoadingUserData.value = false;
      print('-------- $err ---------');
      throw Dialogs.USER_DATA_FETCH;
    }
  }

  Future<void> saveNewUserData(String username, XFile? image) async {
    try {
      isSaveUserDataLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser!.uid;

      if (image != null) {
        final refPath = FirebaseStorage.instance
            .ref()
            .child('user-image')
            .child(userId + '.jpg');

        await refPath.putFile(
          File(image.path),
        );
        final dpUrl = await refPath.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userId).set(
          {
            'username': username,
            'dpUrl': dpUrl,
          },
        );
      } else {
        await FirebaseFirestore.instance.collection('users').doc(userId).set(
          {
            'username': username,
            'dpUrl': currentUserData[0].dpUrl,
          },
        );
      }

      isSaveUserDataLoading.value = false;
    } on FirebaseAuthException {
      isSaveUserDataLoading.value = false;
      throw 'Could not save data at the moment, Please try again later';
    } on SocketException catch (_) {
      isSaveUserDataLoading.value = false;
      throw 'Could not connect to the internet!';
    } catch (err) {
      isSaveUserDataLoading.value = false;
      throw 'Could not save data at the moment, Please try again later';
    }
  }
}
