import 'package:bug_tracker/controllers/projectController/projectController.dart';
import 'package:bug_tracker/utils/newTicketForm/newTicketForm.dart';
import 'package:bug_tracker/utils/ticketDesign/ticketDesign.dart';
import 'package:bug_tracker/views/pages/DetailedTabPages/detailedTabPages.dart';
import 'package:bug_tracker/views/pages/ticketDetailPage/ticketDetailPage.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

class ProjectTicketTab extends StatelessWidget {
  final fetchedProjectId;
  ProjectTicketTab(this.fetchedProjectId);

  final ProjectsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          int projectIndex = controller.projects
              .indexWhere((element) => element.projectId == fetchedProjectId);
          return controller.isTickeSaving.value ||
                  controller.isTicketEditing.value ||
                  controller.isTicketDeleteing.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : controller.projects[projectIndex].ticketDetails.isEmpty
                  ? Center(
                      child: Text('No Tickets Added'),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return TicketDesign(
                          ticketTitle: controller.projects[projectIndex]
                              .ticketDetails[index].ticketTitle,
                          ticketDesc: controller.projects[projectIndex]
                              .ticketDetails[index].ticketDesc,
                          ticketPriority: controller.projects[projectIndex]
                              .ticketDetails[index].ticketPriority,
                          ticketStatus: controller.projects[projectIndex]
                              .ticketDetails[index].ticketStatus,
                          fetchedProjectId: fetchedProjectId,
                          ticketIndex: index,
                        );
                      },
                      itemCount: controller
                          .projects[projectIndex].ticketDetails.length,
                    );
        },
      ),
      floatingActionButton: SizedBox(
        width: 120,
        height: 40,
        child: FloatingActionButton(
          onPressed: () {
            // add ticket
            showModalBottomSheet(
              context: context,
              builder: (BuildContext ctx) {
                return NewTicketForm(fetchedProjectId, ctx, null);
              },
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('+ New Ticket'),
          ),
        ),
      ),
    );
  }
}
