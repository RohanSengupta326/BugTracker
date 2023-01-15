import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/views/widgets/projectFormWidget/projectFormWidget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewProjectForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // submit form and save in DB
            },
            icon: const Icon(
              Icons.check,
            ),
          ),
        ],
        titleSpacing: ConstValues.PADDING,
        backgroundColor: ConstColors.APPBAR_BACKGROUND_COLOR,
        title: const Text(
          "Add Project",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: ConstColors.APPBAR_FONT_COLOR),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProjectFormWidget(),
          ],
        ),
      ),
    );
  }
}
