import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProjectTeamTab extends StatelessWidget {
  final contributors;
  ProjectTeamTab({this.contributors});

  List<Widget> activeContributors() {
    List<Widget> temp = [];

    for (var i = 0; i < contributors.length; i++) {
      temp.add(
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(ConstValues.PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    contributors[i],
                  ),
                ),
                Flexible(
                  child: Text(
                    'senguptarohan34@gmail.comafsdfadfadfadfadfs',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 55,
            child: Card(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(ConstValues.PADDING),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name'),
                    Text('Email'),
                  ],
                ),
              ),
            ),
          ),

          // name - email
          ...activeContributors(),
        ],
      ),
    );
  }
}
