import 'dart:developer';

import 'package:bug_tracker/models/projectDetailModel/projectDetailModel.dart';
import 'package:bug_tracker/models/ticketDetails/ticketDetails.dart';
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
  RxBool isTickeSaving = false.obs;
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

  Future<void> saveProjectDetails(
    String projectName,
    String projectDetails,
    List<UsersDetails> selectedContributors,
  ) async {
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
          'ticketDetails': [],
          'projectId': projectId,
        },
      );

      _projects.add(
        ProjectDetailModel(
            projectName: projectName,
            projectDetails: projectDetails,
            selectedContributors: selectedContributors,
            ticketDetails: [],
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
      List<TicketDetails> savedTickets = [];

      // converting firestore map to UsersDetails type first then storing locally
      for (var i = 0; i < savedProjects.docs.length; i++) {
        savedContributors = [];
        savedTickets = [];
        // for every project's for loop iteration dont store previous project's data is not stored

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

        if (savedProjects.docs[i].data()['ticketDetails'] != []) {
          final List ticketList = savedProjects.docs[i].data()['ticketDetails'];

          for (var tickets in ticketList) {
            final titleTicket = tickets['ticketTitle'];
            final descTicket = tickets['ticketDescription'];
            final priorityTicket = tickets['ticketPriority'];
            final statusTicket = tickets['ticketStatus'];

            final allTicket = TicketDetails(
                titleTicket, descTicket, priorityTicket, statusTicket);
            savedTickets.add(allTicket);
          }
        } else {
          savedTickets = [];
        }

        _projects.add(
          ProjectDetailModel(
            projectName: savedProjects.docs[i].data()['projectName'],
            projectDetails: savedProjects.docs[i].data()['projectDetails'],
            selectedContributors: savedContributors,
            ticketDetails: savedTickets,
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

  Future<void> editProject(
      String projectName,
      String projectDetails,
      List<UsersDetails> selectedContributors,
      String editProjectId,
      List<TicketDetails>? savedTicketDetails) async {
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
          .update(
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
          'ticketDetails': savedTicketDetails!.isEmpty
              ? savedTicketDetails
              : savedTicketDetails
                  .map((ele) => {
                        'ticketDescription': ele.ticketDesc,
                        'ticketPriority': ele.ticketPriority,
                        'ticketStatus': ele.ticketStatus,
                        'ticketTitle': ele.ticketTitle,
                      })
                  .toList(),
          'projectId': editProjectId,
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

      isProjectEditing.value = false;

      rethrow;
    }
  }

  Future<void> saveTicketDetails(String ticketProjectId, String ticketTitle,
      String ticketDesc, String ticketPriority, String ticketStatus) async {
    // List<String> ticketDetailsAlls = [];

    try {
      isTickeSaving.value = true;

      await FirebaseFirestore.instance
          .collection('project-details')
          .doc(ticketProjectId)
          .update(
        {
          'ticketDetails': FieldValue.arrayUnion(
            // without this it was just rewriting the list value, with .arrayUnion it appends only.
            [
              {
                'ticketTitle': ticketTitle,
                'ticketDescription': ticketDesc,
                'ticketPriority': ticketPriority,
                'ticketStatus': ticketStatus,
              },
            ],
          )
        },
      );

      int projectIndex = _projects
          .indexWhere((element) => element.projectId == ticketProjectId);

      _projects[projectIndex].ticketDetails.add(
            TicketDetails(
              ticketTitle,
              ticketDesc,
              ticketPriority,
              ticketStatus,
            ),
          );

      isTickeSaving.value = false;
    } catch (error) {
      log(error.toString());

      isTickeSaving.value = false;

      rethrow;
    }
  }
}
