import 'package:bug_tracker/utils/projectTicketTab/projectTicketTab.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

const status = ['in-progress', 'resolved', 'new'];

class TicketStatusDropDown extends StatelessWidget {
  RxString _dropdownValue = status[0].obs;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Obx(
        () {
          return DropdownButton<String>(
            value: _dropdownValue.value,
            onChanged: (String? value) {
              // This is called when the user selects an item.
              _dropdownValue.value = value!;
              ProjectTicketTab.statusTicket = _dropdownValue.value;
            },
            items: status.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
