import 'package:bug_tracker/models/currUserData/currUserData.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FetchAllUsers extends GetxController {
  List<String> _users = [];
  List<UserData> currentUserData = [
    UserData('', ''),
  ];

  RxBool isUserFetching = false.obs;
  RxBool isLoadingUserData = false.obs;

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
    } catch (error) {
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    }
  }

  Future<void> fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      isLoadingUserData.value = true;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      currentUserData = [
        UserData(
          userData['username'],
          userData['dpUrl'],
        ),
      ];
      isLoadingUserData.value = false;
    } catch (err) {
      isLoadingUserData.value = false;
      throw Dialogs.USER_DATA_FETCH;
    }
  }
}
