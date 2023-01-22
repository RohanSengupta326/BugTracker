import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/views/pages/NewProjectForm/newProjectFormPage.dart';
import 'package:bug_tracker/views/widgets/projectFormWidget/projectFormWidget.dart';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ContributorDropdownWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GFMultiSelect(
        items: NewProjectFormPage.contributors,
        onSelect: (value) {
          // print('---SELECTED CONTRIBUTOR VALUE---- ${value[0]} ');
          // print(
          //     '---SELECTED CONTRIBUTOR---- ${NewProjectFormPage.selectedContributors[0]} ');

          // for (int i = 0; i < value.length; i++) {
          //   NewProjectFormPage.selectedContributorsName![i] =
          //       NewProjectFormPage.contributors[value[i]];
          // }
          NewProjectFormPage.selectedContributorsName
              .add(NewProjectFormPage.contributors[0]);
        },
        dropdownTitleTileText: '--Select--',
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
            fontSize: ConstValues.FONT_SIZE, color: Colors.black54),
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.all(6),
        type: GFCheckboxType.basic,
        activeBgColor: ConstColors.PRIMARY_SWATCH_COLOR,
        inactiveBorderColor: Colors.grey,
      ),
    );
  }
}
