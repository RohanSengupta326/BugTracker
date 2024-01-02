import 'dart:async';
import 'dart:developer';

import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/authUserController/authUserController.dart';

import 'package:bug_tracker/controllers/projectController/projectController.dart';

import 'package:bug_tracker/utils/appdrawer/appdrawer.dart';
import 'package:bug_tracker/utils/project_list_viewer/project_list_viewer.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:bug_tracker/views/pages/NewProjectForm/newProjectFormPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../blankLoadingPage/blank_loading_page.dart';

double responsiveFontSize = Get.width * 0.04;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final projectController = Get.put(ProjectsController());
  final fetchAllUserController = Get.put(AuthUserController());
  RxBool isAllDataFetching = false.obs;
  bool callFetchDetails = true;

  Future<void> fetchDetails([bool callingRefresh = false]) async {
    // print('############  FETCHING ALL DATA  ###########');
    callFetchDetails = false;
    isAllDataFetching.value = true;
    if (!fetchAllUserController.didUserSignIn || callingRefresh) {
      // if user signed in , the sign in functions were called so these functions were already called & data was loaded.
      // if not, then first time have to call to load data.
      // if pulled to refresh, definitely call these fucntions
      await projectController.fetchProject();
      await fetchAllUserController.fetchAllUsers();
      await fetchAllUserController.fetchUserData();
    }
    isAllDataFetching.value = false;
  }

  Widget homePage() {
    // doesnt call fetchdetails everytime Obx runs, rather just once when app starts & refrechIndicator is pulled
    callFetchDetails ? fetchDetails() : null;

    // if page is refreshed , blankloadingpage will be shown as long as all data is being fetched.
    return isAllDataFetching.value
        ? BlankLoadingPage()
        : Scaffold(
            drawer: AppDrawer(),
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    // open new project form
                    Get.to(() => NewProjectFormPage(
                          savedContributors: const [],
                          savedTicketDetails: const [],
                        ));
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
              ],
              titleSpacing: 0,
              backgroundColor: ConstColors.APPBAR_BACKGROUND_COLOR,
              title: const Text(
                "Projects",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: ConstColors.APPBAR_FONT_COLOR),
              ),
            ),
            body: // SHOW SAVED PROJECTS HERE
                RefreshIndicator(
              onRefresh: (() => fetchDetails(true)),
              child:
                  // while fetching saved projects
                  projectController.isProjectFetching.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      // while adding new project
                      : projectController.isProjectSaving.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          // while deleting
                          : projectController.isProjectDeleting.value
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : projectController.isProjectEditing.value
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : projectController.projects.isEmpty
                                      ? const Center(
                                          child: Text("No projects to show !!"),
                                        )
                                      : ListView.builder(
                                          itemBuilder: ((context, index) {
                                            return ProjectListViewer(
                                              projectName: projectController
                                                  .projects[index].projectName,
                                              projectDetails: projectController
                                                  .projects[index]
                                                  .projectDetails,
                                              contributors: projectController
                                                  .projects[index]
                                                  .selectedContributors,
                                              projectId: projectController
                                                  .projects[index].projectId,
                                            );
                                          }),
                                          itemCount: projectController
                                              .projects.length),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //  if any Signin variable is true then show a blank loading page to load everything first (allusers, userdata, project list)
      // else show homepage
      return (!fetchAllUserController.isGoogleLoadingAuth.value &&
              !fetchAllUserController.isLoadingAuth.value)
          ? homePage()
          : BlankLoadingPage();
    });
  }
}
