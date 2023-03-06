import 'package:bug_tracker/utils/newTicketForm/newTicketForm.dart';
import "package:flutter/material.dart";

class ProjectTicketTab extends StatelessWidget {
  static String ticketTitle = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [Text('Tickets')],
      ),
      floatingActionButton: Container(
        width: 120,
        height: 40,
        child: FloatingActionButton(
          onPressed: () {
            // add ticket
            showModalBottomSheet(
                context: context,
                builder: (_) {
                  return NewTicketForm();
                });
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
