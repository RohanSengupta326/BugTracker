import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/ProjectDetailsController/projectDetailsController.dart';
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
  final controller = Get.put(ProjectDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // open new project form
              Get.to(() => NewProjectFormPage());
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
        titleSpacing: ConstValues.PADDING,
        backgroundColor: ConstColors.APPBAR_BACKGROUND_COLOR,
        title: const Text(
          "Bug Tracker",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: ConstColors.APPBAR_FONT_COLOR),
        ),
      ),
      body: // SHOW SAVED PROJECTS HERE
          Obx(
        (() {
          return controller.isProjectSaving.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.projects.isEmpty
                  ? const Center(
                      child: Text("No projects to show !!"),
                    )
                  : ListView.builder(
                      itemBuilder: ((context, index) {
                        return ProjectListViewer(
                          projectName: controller.projects[index].projectName,
                          projectDetails:
                              controller.projects[index].projectDetails,
                        );
                      }),
                      itemCount: controller.projects.length);
        }),
      ),
    );
  }
}
