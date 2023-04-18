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

double responsiveFontSize = Get.width * 0.04;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final projectController = Get.put(ProjectsController());
  final fetchAllUserController = Get.put(AuthUserController());
  RxBool isEmailVerified = false.obs;
  Timer? timer;

  Future<void> fetchDetails() async {
    projectController.fetchProject();
    fetchAllUserController.fetchAllUsers();
    fetchAllUserController.fetchUserData();
  }

  @override
  void initState() {
    isEmailVerified.value = FirebaseAuth.instance.currentUser!.emailVerified;
    log(isEmailVerified.value.toString());

    if (!isEmailVerified.value) {
      fetchAllUserController.sendVerificationMail().catchError((error) {
        Get.snackbar('Oops!', error, duration: Duration(seconds: 3));
      });

      timer = Timer.periodic(
        Duration(seconds: 3),
        (timer) async {
          isEmailVerified.value =
              await fetchAllUserController.checkEmailVerified();
          if (isEmailVerified.value) timer.cancel();
        },
      );
    }

    fetchDetails();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return !isEmailVerified.value
          ? emailVerificatonPage(fetchAllUserController)
          : homePage();
    });
  }

  Scaffold homePage() {
    return Scaffold(
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
        onRefresh: (() => fetchDetails()),
        child: Obx(
          (() {
            // while fetching saved projects
            return projectController.isProjectFetching.value
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
                                            .projects[index].projectDetails,
                                        contributors: projectController
                                            .projects[index]
                                            .selectedContributors,
                                        projectId: projectController
                                            .projects[index].projectId,
                                      );
                                    }),
                                    itemCount:
                                        projectController.projects.length);
          }),
        ),
      ),
    );
  }
}

Scaffold emailVerificatonPage(AuthUserController fetchAllUserController) {
  final screenWidth = Get.width;
  final avatarSize = screenWidth * 0.4;

  return Scaffold(
    appBar: AppBar(
      title: Text('Email Verification'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 150,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundImage: const AssetImage(
                  'assets/images/email.png'), // Replace with your image
            ),
            SizedBox(height: 15),
            Text(
              'Thank you for signing up!',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              'We have sent a verification link to your email',
              style: TextStyle(fontSize: screenWidth * 0.045),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              'Please click on the verification link to complete your registration.',
              style: TextStyle(fontSize: screenWidth * 0.045),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {}, // Replace with your verification link function
              child: Text(
                'Resend Verification Email',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: screenWidth * 0.03,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(ConstColors.ERROR_COLOR)),
              onPressed: () => fetchAllUserController.logOut(),
              child: Text('LogOut'),
            ),
          ],
        ),
      ),
    ),
  );
}
