import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/authUserController/authUserController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePictureView extends StatelessWidget {
  final String profilePictureUrl;
  ProfilePictureView(this.profilePictureUrl);

  final AuthUserController fetchAllUsersController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(5),
      shape: CircleBorder(),
      content: CircleAvatar(
        radius: 300,
        backgroundImage: fetchAllUsersController.currentUserData.isNotEmpty &&
                fetchAllUsersController.currentUserData[0].dpUrl != ''
            ? NetworkImage(profilePictureUrl)
            : const AssetImage('assets/images/userdp.jpg')
                as ImageProvider<Object>,
      ),
    );
  }
}
