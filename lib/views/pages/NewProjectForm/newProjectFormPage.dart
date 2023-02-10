import 'dart:developer';

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
  static String projectName = "";
  static String projectDetails = "";
  static List<dynamic> selectedContributorsName = [];
  static List<int> selectedContributorsIndex = [];
  // to store indices of the selected names from allUsers list

  final FetchAllUsers allUserData = Get.find();
  final ProjectsController formSaveController = Get.put(ProjectsController());

  var savedProjectName;
  var savedProjectDetails;
  var savedContributors;
  var savedProjectId;
  NewProjectFormPage(
      {this.savedProjectName,
      this.savedProjectDetails,
      this.savedContributors,
      this.savedProjectId}) {
    projectName = savedProjectName ?? "";
    projectDetails = savedProjectDetails ?? "";
    selectedContributorsName = savedContributors ?? [];

    for (var i = 0; i < selectedContributorsName.length; i++) {
      selectedContributorsIndex.add(allUserData.users
          .indexWhere((element) => element == selectedContributorsName[i]));
    }
  }

  void onSubmit(BuildContext context) {
    // SUBMIT CONTROLLER FUNCTION CALL TO SAVE IN FIREBASE
    if (savedProjectName == null) {
      log("entering saving");
      // if NOT editing project
      formSaveController
          .saveProjectDetails(
              projectName, projectDetails, selectedContributorsName)
          .then((value) {
        selectedContributorsName = [];
        // for one project contributors are saved now for different projects' contributors shouldnt overlap
        selectedContributorsIndex = [];
        Get.back();
      });
    } else {
      log("editing controller call");

      // if editing project
      formSaveController
          .editProject(projectName, projectDetails, selectedContributorsName,
              savedProjectId)
          .then((value) {
        log("now get back");
        selectedContributorsIndex = [];
        selectedContributorsName = [];
        Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            selectedContributorsIndex = [];
            selectedContributorsName = [];
            //delete saved info or duplicate will occur

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
                    selectedContributorsName
                        .add(allUserData.users[selectedContributorsIndex[i]]);
                  }

                  // onSubmitted to save form and check errors
                  ProjectFormWidget.onSubmitted();

                  if (ProjectFormWidget.isValid) {
                    // if user filled form correctly then progress else not
                    ProjectFormWidget.formKey.currentState!.save();

                    // getting the context from the ProjectFormWidget class
                    FocusScope.of(Get.context!).unfocus();

                    onSubmit(context);
                  }
                },
                icon: formSaveController.isProjectSaving.value ||
                        formSaveController.isProjectEditing.value
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
          "Add/Edit Project",
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
