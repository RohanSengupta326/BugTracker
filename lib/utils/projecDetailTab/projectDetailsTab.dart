import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:flutter/material.dart';

class ProjectDetailTab extends StatelessWidget {
  final projectName;
  final projectDetails;
  ProjectDetailTab({this.projectName, this.projectDetails});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(ConstValues.MARGIN),
              padding: const EdgeInsets.all(ConstValues.PADDING),
              child: Text(
                projectName,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(
                  left: ConstValues.MARGIN, right: ConstValues.MARGIN),
              padding: const EdgeInsets.all(ConstValues.PADDING),
              child: Text(
                projectDetails,
                style: const TextStyle(
                  fontSize: ConstValues.FONT_SIZE,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
