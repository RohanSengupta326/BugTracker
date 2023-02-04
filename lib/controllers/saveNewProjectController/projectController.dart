import 'package:bug_tracker/models/projectDetailModel/projectDetailModel.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProjectsController extends GetxController {
  List<ProjectDetailModel> _projects = [];
  RxBool isProjectSaving = false.obs;
  RxBool isProjectFetching = false.obs;

  List<ProjectDetailModel> get projects {
    return [..._projects];
  }

  Future<void> saveProjectDetails(String projectName, String projectDetails,
      List<String> selectedContributors) async {
    try {
      isProjectSaving.value = true;

      // FIREBASE OPERATIONS
      await FirebaseFirestore.instance.collection('project-details').doc().set(
        {
          'projectName': projectName,
          'projectDetails': projectDetails,
          'selectedContributors':
              selectedContributors.isNotEmpty ? selectedContributors : "",
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

  Future<void> fetchProject() async {
    _projects = [];

    try {
      isProjectFetching.value = true;

      final savedProjects =
          await FirebaseFirestore.instance.collection('project-details').get();

      // log(savedProjects.docs[0].data()['ProjectDetails']);

      for (var i = 0; i < savedProjects.docs.length; i++) {
        _projects.add(
          ProjectDetailModel(
              projectName: savedProjects.docs[i].data()['projectName'],
              projectDetails: savedProjects.docs[i].data()['projectDetails'],
              selectedContributors:
                  savedProjects.docs[i].data()['selectedContributors']),
        );
      }

      isProjectFetching.value = false;
    } on FirebaseAuthException {
      isProjectFetching.value = false;
      throw Dialogs.PROJECT_NOT_SAVED;
    } catch (error) {
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    }
  }
}
