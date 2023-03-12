import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/views/pages/ticketDetailPage/ticketDetailPage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDesign extends StatelessWidget {
  final String ticketTitle;
  final String ticketDesc;
  final String ticketPriority;
  final String ticketStatus;
  TicketDesign(
      {required this.ticketTitle,
      required this.ticketDesc,
      required this.ticketPriority,
      required this.ticketStatus});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.all(16),
        height: 120,
        width: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                ticketTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    color: ticketPriority.toLowerCase() == 'high'
                        ? Colors.red.shade200
                        : Colors.blue.shade200,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(ticketPriority)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(),
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
                    color: ticketStatus.toLowerCase() == 'in-progress'
                        ? Colors.green.shade400
                        : ticketStatus == 'resolved'
                            ? Colors.purple.shade200
                            : Colors.amber.shade200,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(ticketStatus),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
