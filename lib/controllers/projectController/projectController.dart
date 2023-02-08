import 'dart:developer';

import 'package:bug_tracker/models/projectDetailModel/projectDetailModel.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';

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
      List<dynamic> selectedContributors) async {
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
          'selectedContributors':
              selectedContributors.isNotEmpty ? selectedContributors : "",
          'projectId': projectId,
        },
      ).then((value) {
        log('inside then');
        _projects.add(
          ProjectDetailModel(
              projectName: projectName,
              projectDetails: projectDetails,
              selectedContributors: selectedContributors,
              projectId: projectId),
        );
      });
      log('outside then');
      isProjectSaving.value = false;
    } catch (error) {
      isProjectSaving.value = false;
      throw Dialogs.PROJECT_NOT_SAVED;
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
                savedProjects.docs[i].data()['selectedContributors'],
            projectId: savedProjects.docs[i].data()['projectId'],
          ),
        );
      }

      isProjectFetching.value = false;
    } catch (error) {
      isProjectFetching.value = false;
      throw Dialogs.GENERIC_ERROR_MESSAGE;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      isProjectDeleting.value = true;

      await FirebaseFirestore.instance
          .collection('project-details')
          .doc(projectId)
          .delete()
          .then((value) {
        _projects.removeAt(
          _projects.indexWhere((element) => element.projectId == projectId),
        );
      });

      isProjectDeleting.value = false;
    } catch (error) {
      isProjectDeleting.value = false;
      throw Dialogs.PROJECT_NOT_DELETED;
    }
  }

  Future<void> editProject(String projectName, String projectDetails,
      List<dynamic> selectedContributors, String editProjectId) async {
    log("entered function");
    log(editProjectId);
    for (var i = 0; i < selectedContributors.length; i++) {
      log(selectedContributors[i]);
    }

    try {
      isProjectEditing.value = true;
      log("isProjectEditing = $isProjectEditing");

      // FIREBASE OPERATIONS
      await FirebaseFirestore.instance
          .collection('project-details')
          .doc(editProjectId)
          .update(
        {
          'projectName': projectName,
          'projectDetails': projectDetails,
          'selectedContributors':
              selectedContributors.isNotEmpty ? selectedContributors : "",
        },
      ).then((value) {
        log('firebase operation done');
        int index =
            _projects.indexWhere((element) => element.projectId == projectId);

        _projects[index].projectDetails = projectDetails;
        _projects[index].projectName = projectName;
        _projects[index].selectedContributors = selectedContributors;
      });

      log("all done");
      isProjectEditing.value = false;
    } catch (error) {
      isProjectEditing.value = false;
      throw Dialogs.PROJECT_NOT_SAVED;
    }
  }
}
