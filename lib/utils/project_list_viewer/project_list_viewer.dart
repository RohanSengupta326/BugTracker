import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/views/pages/DetailedTabPages/detailedTabPages.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectListViewer extends StatelessWidget {
  final projectName;
  final projectDetails;
  final contributors;
  final projectId;
  ProjectListViewer(
      {this.projectName,
      this.projectDetails,
      this.contributors,
      this.projectId});

  List<Widget> currentContributors() {
    // chip widget to show active contributors for particular projects
    List<Widget> names = [];
    for (var i = 0; i < contributors.length; i++) {
      names.add(Container(
        margin: EdgeInsets.only(right: ConstValues.VALUE_3),
        child: Chip(
          label: Text(
            contributors[i],
            style: TextStyle(fontSize: ConstValues.FONT_SIZE_12),
          ),
        ),
      ));
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    String projectDetailShort = projectDetails.replaceAll("\n", " ");

    return Container(
      margin: const EdgeInsets.only(
          left: ConstValues.MARGIN,
          right: ConstValues.MARGIN,
          top: ConstValues.MARGIN),
      height: 152,
      child: GestureDetector(
        onTap: (() {
          Get.to(() => DetailedTabPages(
                projectName: projectName,
                projectDetails: projectDetails,
                contributors: contributors,
                projectId: projectId,
              ));
        }),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ConstValues.MARGIN),
          ),
          child: Padding(
            padding: const EdgeInsets.all(ConstValues.PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    projectName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ConstValues.HEADING_FONT_SIZE,
                      color: ConstColors.PRIMARY_SWATCH_COLOR,
                    ),
                  ),
                ),
                const SizedBox(
                  height: ConstValues.VALUE_16 / 2,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(projectDetails.length > 42
                      ? ("${projectDetailShort.substring(0, 42)}... ")
                      : projectDetails),
                ),
                const SizedBox(
                  height: ConstValues.VALUE_16,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: currentContributors(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
