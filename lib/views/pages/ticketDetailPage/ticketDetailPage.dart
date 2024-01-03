import 'dart:developer';

import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/projectController/projectController.dart';
import 'package:bug_tracker/models/projectDetailModel/projectDetailModel.dart';
import 'package:bug_tracker/utils/newTicketForm/newTicketForm.dart';
import 'package:bug_tracker/views/pages/DetailedTabPages/detailedTabPages.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/ticketDetails/ticketDetails.dart';
import '../../dialogs/dialogs.dart';
import '../../widgets/confirmationAlertBoxWidget/confirmationAlertBoxWidget.dart';

class TicketDetailPage extends StatelessWidget {
  final String fetchedProjectId;
  final int ticketIndex;
  TicketDetailPage({required this.fetchedProjectId, required this.ticketIndex});

  final ProjectsController controller = Get.find();

  List<ProjectDetailModel> _projects = [];
  late int projectIndex;
  TicketDetails ticketDetails = TicketDetails('', '', '', '');

  void fetchUpdatedProjects() {
    _projects = controller.projects;
    projectIndex = _projects
        .indexWhere((element) => element.projectId == fetchedProjectId);
    ticketDetails = _projects[projectIndex].ticketDetails[ticketIndex];
  }

  void deleteTicket() async {
    await controller.deleteTicket(
        fetchedProjectId,
        ticketIndex,
        ticketDetails.ticketTitle,
        ticketDetails.ticketDesc,
        ticketDetails.ticketPriority,
        ticketDetails.ticketStatus);
    //
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    fetchUpdatedProjects();
    // fetchProjectDetails in first build & when edited, fetch the project list again with updates.

    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
        backgroundColor: Colors.grey,
        actions: [
          // IF ADMIN SHOW THIS BUTTON ELSE NOT

          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext ctx) {
                  return NewTicketForm(fetchedProjectId, ctx, ticketIndex,
                      isEdit: true);
                },
              );
            },
            icon: const Icon(
              Icons.edit,
            ),
            iconSize: 20,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              deleteTicket();
            },
          )
        ],
      ),
      body: Obx(
        () {
          fetchUpdatedProjects();
          // fetch new project details

          return controller.isTicketEditing.value
              ? Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(ConstValues.MARGIN),
                        padding: const EdgeInsets.all(ConstValues.PADDING),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: FittedBox(
                                child: Text(
                                  'Priority : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                color: ticketDetails.ticketPriority
                                            .toLowerCase() ==
                                        'high'
                                    ? Colors.red.shade200
                                    : Colors.blue.shade200,
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(ticketDetails.ticketPriority)),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                'Status : ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                color: ticketDetails.ticketStatus
                                            .toLowerCase() ==
                                        'in-progress'
                                    ? Colors.green.shade400
                                    : ticketDetails.ticketStatus == 'resolved'
                                        ? Colors.purple.shade200
                                        : Colors.amber.shade200,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(ticketDetails.ticketStatus),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.all(ConstValues.MARGIN),
                          padding: const EdgeInsets.all(ConstValues.PADDING),
                          child: Text(
                            ticketDetails.ticketTitle,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: ConstValues.MARGIN,
                              right: ConstValues.MARGIN),
                          padding: const EdgeInsets.all(ConstValues.PADDING),
                          child: Text(
                            ticketDetails.ticketDesc,
                            style: const TextStyle(
                              fontSize: ConstValues.FONT_SIZE,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
