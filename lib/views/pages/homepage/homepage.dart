import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/fetchAllUsers/fetchAllUsersController.dart';
import 'package:bug_tracker/controllers/projectController/projectController.dart';

import 'package:bug_tracker/utils/appdrawer/appdrawer.dart';
import 'package:bug_tracker/utils/project_list_viewer/project_list_viewer.dart';
import 'package:bug_tracker/views/pages/NewProjectForm/newProjectFormPage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final projectController = Get.put(ProjectsController());
  final fetchAllUserController = Get.put(FetchAllUsers());

  @override
  void initState() {
    projectController.fetchProject();
    fetchAllUserController.fetchAllUsers();
    fetchAllUserController.fetchUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // open new project form
              Get.to(() => NewProjectFormPage(
                    savedContributors: null,
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
          Obx(
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
                                          .projects[index].selectedContributors,
                                      projectId: projectController
                                          .projects[index].projectId,
                                    );
                                  }),
                                  itemCount: projectController.projects.length);
        }),
      ),
    );
  }
}
