import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/ProjectDetailsController/projectDetailsController.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:bug_tracker/views/widgets/alertBoxWidget/alertBoxWidget.dart';
import 'package:bug_tracker/views/widgets/projectFormWidget/projectFormWidget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewProjectFormPage extends StatelessWidget {
  static String projectName = "";
  static String projectDetails = "";

  static List<String>? selectedContributorsName = [];

  // contributors list will be fetched from FIREBASE
  static List<String> contributors = ["Rohan Sengupta", "Raj Sen"];

  final formSaveController = Get.put(ProjectDetailsController());

  void onSubmit(BuildContext context) {
    // SUBMIT CONTROLLER FUNCTION CALL TO SAVE IN FIREBASE
    formSaveController
        .saveProjectDetails(
            projectName, projectDetails, selectedContributorsName)
        .catchError(
      (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertBoxWidget(error);
          },
        );
      },
    );
  }

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
              // onSubmitted to save form and check errors
              ProjectFormWidget.onSubmitted();
              // getting the context from the ProjectFormWidget class
              FocusScope.of(ProjectFormWidget.currentContext).unfocus();
              onSubmit(context);
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
