import 'package:bug_tracker/views/dialogs/dialogs.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FetchAllUsers extends GetxController {
  List<String> _users = [];
  RxBool isUserFetching = false.obs;

  List<String> get users {
    return [..._users];
  }

  Future<void> fetchAllUsers() async {
    _users = [];

    try {
      isUserFetching.value = true;

      final allUsers =
          await FirebaseFirestore.instance.collection('users').get();

      for (var i = 0; i < allUsers.docs.length; i++) {
        _users.add(
          allUsers.docs[i].data()['username'],
        );
      }

      isUserFetching.value = false;
    } on FirebaseAuthException {
      isUserFetching.value = false;
      throw Dialogs.PROJECT_NOT_SAVED;
    } catch (error) {
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    }
  }
}
