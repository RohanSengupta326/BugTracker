import 'package:bug_tracker/controllers/projectController/projectController.dart';
import 'package:bug_tracker/utils/newTicketForm/newTicketForm.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

class ProjectTicketTab extends StatelessWidget {
  final fetchedProjectId;
  ProjectTicketTab(this.fetchedProjectId);

  final ProjectsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    int projectIndex = controller.projects
        .indexWhere((element) => element.projectId == fetchedProjectId);

    return Scaffold(
      body: Obx(
        () {
          return controller.isTickeSaving.value
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
                        return SizedBox(
                          height: 50,
                          width: 300,
                          child: Card(
                            child: Center(
                              child: Text(controller.projects[projectIndex]
                                  .ticketDetails[index].ticketTitle),
                            ),
                          ),
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
              builder: (_) {
                return NewTicketForm(fetchedProjectId);
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
