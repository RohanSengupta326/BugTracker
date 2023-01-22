import 'package:bug_tracker/models/projectDetailModel/projectDetailModel.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProjectDetailsController extends GetxController {
  List<ProjectDetailModel> _projects = [];
  RxBool isProjectSaving = false.obs;

  List<ProjectDetailModel> get projects {
    return [..._projects];
  }

  Future<void> saveProjectDetails(String projectName, String projectDetails,
      List<String> selectedContributors) async {
    try {
      isProjectSaving.value = true;

      // FIREBASE OPERATIONS
      await FirebaseFirestore.instance
          .collection('project-details')
          .doc(projectName)
          .set(
        {
          'projectName': projectName,
          'ProjectDetails': projectDetails,
          'selectedContributors':
              selectedContributors.isNotEmpty ? selectedContributors : null,
        },
      ).then((value) {
        _projects.add(
          ProjectDetailModel(
              projectName: projectName,
              projectDetails: projectDetails,
              selectedContributors: selectedContributors),
        );
      });
      isProjectSaving.value = false;
    } on FirebaseAuthException {
      isProjectSaving.value = false;
      throw Dialogs.PROJECT_NOT_SAVED;
    } catch (error) {
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    }
  }
}
