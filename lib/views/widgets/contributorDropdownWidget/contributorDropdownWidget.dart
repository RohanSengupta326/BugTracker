import 'dart:developer';

import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/authUserController/authUserController.dart';

import 'package:bug_tracker/views/pages/NewProjectForm/newProjectFormPage.dart';
import 'package:bug_tracker/views/widgets/projectFormWidget/projectFormWidget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class ContributorDropdownWidget extends StatelessWidget {
  final AuthUserController allUserData = Get.find();
  List<int> temp = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GFMultiSelect(
        initialSelectedItemsIndex:
            NewProjectFormPage.selectedContributorsIndex.isEmpty
                ? null
                : NewProjectFormPage.selectedContributorsIndex,
        items: allUserData.users.map((user) => user.name).toList(),
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

          NewProjectFormPage.selectedContributorsIndex = temp;
          // will be set multiple times, as many times as onSelect gets called
          // value is the list of indices of selected names from the allUsers list.
          // finally all the final indices of names put into another list to access in newProjectFormPage.
        },
        dropdownTitleTileText: '----Assign to----',
        dropdownTitleTileColor: ConstColors.HINT_COLOR,
        dropdownTitleTileMargin: const EdgeInsets.all(
          ConstValues.MARGIN,
        ),
        dropdownTitleTilePadding: const EdgeInsets.all(ConstValues.PADDING / 2),
        dropdownUnderlineBorder:
            const BorderSide(color: Colors.transparent, width: 2),
        dropdownTitleTileBorder: Border.all(color: Colors.grey, width: 1),
        dropdownTitleTileBorderRadius: BorderRadius.circular(5),
        expandedIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black54,
        ),
        collapsedIcon: const Icon(
          Icons.keyboard_arrow_up,
          color: Colors.black54,
        ),
        submitButton: Text('OK'),
        dropdownTitleTileTextStyle: const TextStyle(
            fontSize: ConstValues.FONT_SIZE,
            color: ConstColors.APPBAR_FONT_COLOR),
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.all(6),
        type: GFCheckboxType.circle,
        activeBgColor: ConstColors.PRIMARY_SWATCH_COLOR,
        inactiveBorderColor: Colors.grey,
      ),
    );
  }
}
