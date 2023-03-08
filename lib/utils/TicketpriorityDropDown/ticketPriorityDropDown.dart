import 'package:bug_tracker/consts/const_colors/constColors.dart';

import 'package:flutter/material.dart';

import 'package:getwidget/getwidget.dart';

class TicketPriorityDropDown extends StatelessWidget {
  List<int> temp = [];

  @override
  Widget build(BuildContext context) {
    return GFMultiSelect(
      // initialSelectedItemsIndex:
      //     NewProjectFormPage.selectedContributorsIndex.isEmpty
      //         ? null
      //         : NewProjectFormPage.selectedContributorsIndex,
      items: const ['High', 'Low'],
      onSelect: (value) {
        // for (int i = 0; i < value.length; i++) {
        //   log("${value[i]} \n");
        // }

        // onSelect is getting called multiple times so same indices are adding again and again, so
        // emptying and readding new values
        temp = [];

        for (var i = 0; i < value.length; i++) {
          temp.add(value[i]);
        }
        // value is List<dynamic> but initial selectedIndex is list<int> so we'll be needing list int
        // thats why this extra for loop from value to temp

        // for (var i = 0; i < temp.length; i++) {
        //   log(temp[i].toString());
        // }

        // NewProjectFormPage.selectedContributorsIndex = temp;
        // will be set multiple times, as many times as onSelect gets called
        // value is the list of indices of selected names from the allUsers list.
        // finally all the final indices of names put into another list to access in newProjectFormPage.
      },
      dropdownTitleTileText: 'Priority',
      dropdownTitleTileColor: Colors.white,
      dropdownTitleTilePadding: const EdgeInsets.all(5),

      dropdownTitleTileBorder: Border.all(color: Colors.blue, width: 1),
      dropdownTitleTileBorderRadius: BorderRadius.circular(5),
      expandedIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey,
      ),
      collapsedIcon: const Icon(
        Icons.keyboard_arrow_up,
        color: Colors.grey,
      ),
      submitButton: Text('OK'),
      dropdownTitleTileTextStyle:
          const TextStyle(fontSize: 14, color: Colors.grey),
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(2),
      type: GFCheckboxType.circle,
      activeBgColor: ConstColors.PRIMARY_SWATCH_COLOR,
      inactiveBorderColor: Colors.grey,
      hideDropdownUnderline: true,
      listItemTextColor: Colors.grey,
      size: 20,
    );
  }
}
