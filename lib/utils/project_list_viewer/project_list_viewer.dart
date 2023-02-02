import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';

import 'package:flutter/material.dart';

class ProjectListViewer extends StatelessWidget {
  final projectName;
  final projectDetails;
  final contributors;
  ProjectListViewer({this.projectName, this.projectDetails, this.contributors});

  List<Widget> currentContributors() {
    List<Widget> names = [];
    for (var i = 0; i < contributors.length; i++) {
      names.add(Chip(
        label: Text(
          contributors[i],
          style: TextStyle(fontSize: ConstValues.FONT_SIZE_12),
        ),
      ));
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: ConstValues.MARGIN,
          right: ConstValues.MARGIN,
          top: ConstValues.MARGIN),
      height: 152,
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
                child: Text(projectDetails.length > 50
                    ? (projectDetails.substring(0, 50) + "...")
                    : projectDetails),
              ),
              const SizedBox(
                height: ConstValues.VALUE_16,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: currentContributors(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
