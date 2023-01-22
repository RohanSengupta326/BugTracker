import 'package:flutter/material.dart';

class ProjectListViewer extends StatelessWidget {
  final projectName;
  final projectDetails;
  ProjectListViewer({this.projectName, this.projectDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Text(projectName),
      ),
    );
  }
}
