import 'package:bug_tracker/views/pages/DetailedTabPages/detailedTabPages.dart';
import 'package:flutter/material.dart';

class TicketDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Center(child: Text('TicketDetails')),
      ),
      onWillPop: () async {
        DetailedTabPages.showTicketDetailPage.value = false;
        return false;
      },
    );
  }
}
