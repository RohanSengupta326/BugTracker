import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfilePictureView extends StatelessWidget {
  final String profilePictureUrl;
  ProfilePictureView(this.profilePictureUrl);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue,
      contentPadding: EdgeInsets.all(5),
      content: SizedBox(
        height: 250,
        width: 500,
        child: Image.network(
          profilePictureUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
