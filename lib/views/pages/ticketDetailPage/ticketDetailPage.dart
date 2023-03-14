import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/views/pages/DetailedTabPages/detailedTabPages.dart';
import 'package:flutter/material.dart';

class TicketDetailPage extends StatelessWidget {
  final String ticketTitle;
  final String ticketDesc;
  final String ticketPriority;
  final String ticketStatus;
  TicketDetailPage(
      {required this.ticketTitle,
      required this.ticketDesc,
      required this.ticketPriority,
      required this.ticketStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit,
            ),
            iconSize: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
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
                      color: ticketPriority.toLowerCase() == 'high'
                          ? Colors.red.shade200
                          : Colors.blue.shade200,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(ticketPriority)),
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
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.all(ConstValues.MARGIN),
                padding: const EdgeInsets.all(ConstValues.PADDING),
                child: Text(
                  ticketTitle,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
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
                  ticketDesc,
                  style: const TextStyle(
                    fontSize: ConstValues.FONT_SIZE,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
