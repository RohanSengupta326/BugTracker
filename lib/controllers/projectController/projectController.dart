import 'dart:developer';

import 'package:bug_tracker/models/projectDetailModel/projectDetailModel.dart';
import 'package:bug_tracker/models/usersDetails/usersDetails.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:bug_tracker/views/widgets/alertBoxWidget/alertBoxWidget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ProjectsController extends GetxController {
  List<ProjectDetailModel> _projects = [];
  RxBool isProjectSaving = false.obs;
  RxBool isProjectFetching = false.obs;
  RxBool isProjectDeleting = false.obs;
  RxBool isProjectEditing = false.obs;
  String projectId = "";

  List<ProjectDetailModel> get projects {
    return [..._projects];
  }

  //timebased projectId
  String generateUid() {
    var uuid = Uuid();
    projectId = uuid.v1();
    return projectId;
  }

  Future<void> saveProjectDetails(String projectName, String projectDetails,
      List<UsersDetails> selectedContributors) async {
    log("Starting saving");

    try {
      isProjectSaving.value = true;

      // FIREBASE OPERATIONS
      await FirebaseFirestore.instance
          .collection('project-details')
          .doc(generateUid())
          .set(
        {
          'projectName': projectName,
          'projectDetails': projectDetails,
          'selectedContributors': selectedContributors.isNotEmpty
              ? selectedContributors
                  .map((user) => {
                        'name': user.name,
                        'email': user.email,
                      })
                  .toList()
              : [],
          'projectId': projectId,
        },
      );

      _projects.add(
        ProjectDetailModel(
            projectName: projectName,
            projectDetails: projectDetails,
            selectedContributors: selectedContributors,
            projectId: projectId),
      );

      log('outside then');
      isProjectSaving.value = false;
    } catch (error) {
      log(error.toString());

      showDialog(
        context: Get.context!,
        builder: (_) {
          return AlertBoxWidget(Dialogs.PROJECT_NOT_SAVED);
        },
      );

      isProjectSaving.value = false;
    }
  }

  Future<void> fetchProject() async {
    _projects = [];

    try {
      isProjectFetching.value = true;

      final savedProjects =
          await FirebaseFirestore.instance.collection('project-details').get();

      // log(savedProjects.docs[0].data()['ProjectDetails']);
      List<UsersDetails> savedContributors = [];

      for (var i = 0; i < savedProjects.docs.length; i++) {
        // converting firestore map to UsersDetails type first then storing locally
        if (savedProjects.docs[i].data()['selectedContributors'] != []) {
          final List contributorsList =
              savedProjects.docs[i].data()['selectedContributors'];

          for (var contributor in contributorsList) {
            final name = contributor['name'];
            final email = contributor['email'];
            final user = UsersDetails(name, email);
            savedContributors.add(user);
          }
        } else {
          savedContributors = [];
        }

        _projects.add(
          ProjectDetailModel(
            projectName: savedProjects.docs[i].data()['projectName'],
            projectDetails: savedProjects.docs[i].data()['projectDetails'],
            selectedContributors: savedContributors,
            projectId: savedProjects.docs[i].data()['projectId'],
          ),
        );
      }

      isProjectFetching.value = false;
    } catch (error) {
      log(error.toString());

      showDialog(
        context: Get.context!,
        builder: (_) {
          return AlertBoxWidget(Dialogs.GENERIC_ERROR_MESSAGE);
        },
      );

      isProjectFetching.value = false;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      isProjectDeleting.value = true;

      await FirebaseFirestore.instance
          .collection('project-details')
          .doc(projectId)
          .delete();

      _projects.removeAt(
        _projects.indexWhere((element) => element.projectId == projectId),
      );

      isProjectDeleting.value = false;
    } catch (error) {
      log(error.toString());

      showDialog(
        context: Get.context!,
        builder: (_) {
          return AlertBoxWidget(Dialogs.PROJECT_NOT_DELETED);
        },
      );

      isProjectDeleting.value = false;
    }
  }

  Future<void> editProject(String projectName, String projectDetails,
      List<UsersDetails> selectedContributors, String editProjectId) async {
    // log("entered function");
    // log(editProjectId);
    // for (var i = 0; i < selectedContributors.length; i++) {
    //   log(selectedContributors[i].name);
    // }

    try {
      isProjectEditing.value = true;
      log("isProjectEditing = $isProjectEditing");

      // FIREBASE OPERATIONS
      await FirebaseFirestore.instance
          .collection('project-details')
          .doc(editProjectId)
          .set(
        {
          'projectName': projectName,
          'projectDetails': projectDetails,
          'selectedContributors':
              selectedContributors.isNotEmpty ? selectedContributors : [],
        },
      );

      log('firebase operation done');
      int index =
          _projects.indexWhere((element) => element.projectId == editProjectId);

      _projects[index].projectDetails = projectDetails;
      _projects[index].projectName = projectName;
      _projects[index].selectedContributors = selectedContributors;

      log("all done");
      isProjectEditing.value = false;
    } catch (error) {
      log(error.toString());

      showDialog(
        context: Get.context!,
        builder: (BuildContext ctx) {
          return AlertBoxWidget(Dialogs.PROJECT_NOT_SAVED);
        },
      );

      isProjectEditing.value = false;
    }
  }
}
