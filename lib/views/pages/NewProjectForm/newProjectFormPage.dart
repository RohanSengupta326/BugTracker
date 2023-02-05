import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/fetchAllUsers/fetchAllUsersController.dart';
import 'package:bug_tracker/controllers/projectController/projectController.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:bug_tracker/views/widgets/alertBoxWidget/alertBoxWidget.dart';
import 'package:bug_tracker/views/widgets/projectFormWidget/projectFormWidget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewProjectFormPage extends StatelessWidget {
  final FetchAllUsers allUserData = Get.find();
  final ProjectsController formSaveController = Get.put(ProjectsController());

  static String projectName = "";
  static String projectDetails = "";

  static List<String> selectedContributorsName = [];
  static List<dynamic> selectedContributorsIndex = [];
  // to store indices of the selected names from allUsers list

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
    ).then((value) {
      Get.back();
      selectedContributorsName = [];
      // for one project contributors are saved now for different projects' contributors shouldnt overlap
    });
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
          Obx(
            () {
              return IconButton(
                onPressed: () {
                  // storing all the selected names in selected contributors list.
                  for (int i = 0; i < selectedContributorsIndex.length; i++) {
                    NewProjectFormPage.selectedContributorsName
                        .add(allUserData.users[selectedContributorsIndex[i]]);
                  }

                  // onSubmitted to save form and check errors
                  ProjectFormWidget.onSubmitted();
                  // getting the context from the ProjectFormWidget class
                  FocusScope.of(ProjectFormWidget.currentContext).unfocus();
                  onSubmit(context);
                },
                icon: formSaveController.isProjectSaving.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.check,
                      ),
              );
            },
          )
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
