import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/models/usersDetails/usersDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProjectTeamTab extends StatelessWidget {
  final List<UsersDetails> contributors;
  ProjectTeamTab({required this.contributors});

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
                  flex: 1,
                  child: Text(
                    contributors[i].name.toString(),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    contributors[i].email.toString(),
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
