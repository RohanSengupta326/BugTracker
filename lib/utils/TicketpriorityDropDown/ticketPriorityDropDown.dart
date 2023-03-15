import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/utils/newTicketForm/newTicketForm.dart';
import 'package:bug_tracker/utils/projectTicketTab/projectTicketTab.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getwidget/getwidget.dart';

const priorityList = ['High', 'Low'];

class TicketPriorityDropDown extends StatelessWidget {
  RxString _dropdownValue = priorityList[0].obs;

  @override
  Widget build(BuildContext context) {
    NewTicketForm.priorityTicket = NewTicketForm.priorityTicket.isEmpty
        ? _dropdownValue.value
        : NewTicketForm.priorityTicket;
    // take default value if not changed

    return Align(
      alignment: Alignment.topCenter,
      child: Obx(
        () {
          return DropdownButton<String>(
            value: NewTicketForm.priorityTicket.isEmpty
                ? _dropdownValue.value
                : NewTicketForm.priorityTicket,
            onChanged: (String? value) {
              // This is called when the user selects an item.
              _dropdownValue.value = value!;
              NewTicketForm.priorityTicket = _dropdownValue.value;
            },
            items: priorityList.map<DropdownMenuItem<String>>((String value) {
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
