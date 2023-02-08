import 'dart:developer';

import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/projectController/projectController.dart';
import 'package:bug_tracker/utils/projecDetailTab/projectDetailsTab.dart';
import 'package:bug_tracker/utils/projectTeamTab/projectTeamTab.dart';
import 'package:bug_tracker/utils/projectTicketTab/projectTicketTab.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:bug_tracker/views/pages/NewProjectForm/newProjectFormPage.dart';
import 'package:bug_tracker/views/widgets/alertBoxWidget/alertBoxWidget.dart';
import 'package:bug_tracker/views/widgets/confirmationAlertBoxWidget/confirmationAlertBoxWidget.dart';
import 'package:bug_tracker/views/widgets/indicatorBox/indicatorBox.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedTabPages extends StatelessWidget {
  final projectName;
  final projectDetails;
  final contributors;
  final projectId;
  DetailedTabPages(
      {this.projectName,
      this.projectDetails,
      this.contributors,
      this.projectId});

  final ProjectsController projectsController = Get.find();

  var _controller;
  static bool confirmDelete = false;

  void deleteProject() {
    showDialog(
        context: Get.context!,
        builder: (_) {
          return ConfirmationAlertBoxWidget(
              Dialogs.PROJECT_DELETE_CONFIRMATION);
        }).then((value) {
      // if user clicked ok then confirmDelete value changed to true

      if (confirmDelete) {
        log("---INITIATING DELETE---");
        projectsController.deleteProject(projectId).catchError((error) {
          return showDialog(
              context: Get.context!,
              builder: (_) {
                return AlertBoxWidget(error);
              });
        }).then((value) => Get.back());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Builder(
        builder: ((context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: false,
              titleSpacing: 0,
              actions: [
                IconButton(
                  icon: const Icon(
                    size: 20,
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    //edit existing project
                    Get.to(
                      NewProjectFormPage(
                          savedProjectName: projectName,
                          savedProjectDetails: projectDetails,
                          savedContributors: contributors,
                          savedProjectId: projectId),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    size: 20,
                    Icons.delete,
                    color: ConstColors.ERROR_COLOR,
                  ),
                  onPressed: () {
                    // confirm delete check
                    deleteProject();
                  },
                ),
              ],
              title: const Text(
                'Details',
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              bottom: TabBar(
                // tabs
                controller: _controller,
                labelColor: ConstColors.PRIMARY_SWATCH_COLOR,
                // selected tab color
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ConstValues.FONT_SIZE,
                ),
                // selected tab text style
                unselectedLabelColor: Colors.black54,
                // unselected tab color
                unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: ConstValues.FONT_SIZE - 2),
                // unselected tab text style
                indicatorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                // underline below tab while selected
                indicatorSize: TabBarIndicatorSize.label,
                // length of the indicator
                tabs: const [
                  // different tabs
                  Tab(
                    child: Text(
                      'Project',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Team',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Tickets',
                    ),
                  ),
                ],
              ),
            ),
            body: Obx(() {
              return Stack(
                children: [
                  TabBarView(
                    controller: _controller,
                    children: [
                      ProjectDetailTab(
                          projectName: projectName,
                          projectDetails: projectDetails),
                      ProjectTeamTab(
                        contributors: contributors,
                      ),
                      ProjectTicketTab(),
                    ],
                  ),

                  // while deleting show this on top of screen
                  projectsController.isProjectDeleting.value
                      ? IndicatorBox()
                      : Center(),
                ],
              );
            }),
          );
        }),
      ),
    );
  }
}
