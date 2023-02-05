import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/utils/appdrawer/appdrawer.dart';
import 'package:bug_tracker/utils/projecDetailTab/projectDetailsTab.dart';
import 'package:bug_tracker/utils/projectTeamTab/projectTeamTab.dart';
import 'package:bug_tracker/utils/projectTicketTab/projectTicketTab.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedTabPages extends StatelessWidget {
  final projectName;
  final projectDetails;
  final contributors;
  DetailedTabPages({this.projectName, this.projectDetails, this.contributors});

  var _controller;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Builder(
        builder: ((context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: false,
              titleSpacing: 0,
              actions: [
                IconButton(
                  icon: Icon(
                    size: 20,
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    size: 20,
                    Icons.delete,
                    color: ConstColors.ERROR_COLOR,
                  ),
                  onPressed: () {},
                ),
              ],
              title: const Text(
                'Details',
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              bottom: TabBar(
                // tabs
                controller: _controller,
                labelColor: ConstColors.PRIMARY_SWATCH_COLOR,
                // selected tab color
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ConstValues.FONT_SIZE,
                ),
                // selected tab text style
                unselectedLabelColor: Colors.black54,
                // unselected tab color
                unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: ConstValues.FONT_SIZE - 2),
                // unselected tab text style
                indicatorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                // underline below tab while selected
                indicatorSize: TabBarIndicatorSize.label,
                // length of the indicator
                tabs: const [
                  // different tabs
                  Tab(
                    child: Text(
                      'Project',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Team',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Tickets',
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _controller,
              children: [
                ProjectDetailTab(
                    projectName: projectName, projectDetails: projectDetails),
                ProjectTeamTab(
                  contributors: contributors,
                ),
                ProjectTicketTab(),
              ],
            ),
          );
        }),
      ),
    );
  }
}
