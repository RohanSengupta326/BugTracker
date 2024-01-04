import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:bug_tracker/views/pages/NewProjectForm/newProjectFormPage.dart';
import 'package:bug_tracker/views/widgets/contributorDropdownWidget/contributorDropdownWidget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectFormWidget extends StatelessWidget {
  static GlobalKey<FormState> formKey = GlobalKey();

  static bool isValid = false;

  static void onSubmitted() {
    isValid = formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(ConstValues.PADDING),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              // CODE TO SELECT CONTRIBUTORS
              ContributorDropdownWidget(),

              TextFormField(
                maxLines: 1,
                style: TextStyle(color: Colors.black),
                cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                validator: (value) {
                  if (value!.isEmpty) {
                    return Dialogs.EMPTY_FIELD;
                  }
                  return null;
                },
                initialValue: NewProjectFormPage.projectName,
                key: ValueKey('Project Name'),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: ConstColors.PRIMARY_SWATCH_COLOR),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: ConstColors.PRIMARY_SWATCH_COLOR,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: ConstColors.ERROR_COLOR,
                    ),
                  ),
                  focusColor: ConstColors.PRIMARY_SWATCH_COLOR,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ConstColors.PRIMARY_SWATCH_COLOR,
                    ),
                  ),
                  hintText: 'Project Name',
                  hintStyle: TextStyle(
                    color: ConstColors.HINT_COLOR,
                  ),
                ),
                onSaved: (value) {
                  NewProjectFormPage.projectName = value as String;
                },
              ),

              SizedBox(
                height: ConstValues.VALUE_16,
              ),
              TextFormField(
                maxLines: Get.height < 412 ? 15 : 23,
                style: TextStyle(color: ConstColors.APP_FONT_COLOR),
                cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                validator: (value) {
                  if (value!.isEmpty) {
                    return Dialogs.EMPTY_FIELD;
                  }
                  return null;
                },
                key: ValueKey('Project Details'),
                initialValue: NewProjectFormPage.projectDetails,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: ConstColors.PRIMARY_SWATCH_COLOR),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: ConstColors.PRIMARY_SWATCH_COLOR,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: ConstColors.ERROR_COLOR,
                    ),
                  ),
                  focusColor: ConstColors.PRIMARY_SWATCH_COLOR,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: ConstColors.PRIMARY_SWATCH_COLOR,
                    ),
                  ),
                  hintText: 'Project Details',
                  hintStyle: TextStyle(
                    color: ConstColors.HINT_COLOR,
                  ),
                ),
                onSaved: (value) {
                  NewProjectFormPage.projectDetails = value as String;
                },
              ),
              SizedBox(
                height: ConstValues.VALUE_16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
