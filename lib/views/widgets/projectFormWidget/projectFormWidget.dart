import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:bug_tracker/views/widgets/contributorDropdownWidget/contributorDropdownWidget.dart';

import 'package:flutter/material.dart';

class ProjectFormWidget extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String _projectName = "";
  String _projectDetails = "";
  List<String> _contributors = ["Rohan Sengupta", "Raj Sen"];

  void onSubmitted(BuildContext context) {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
    }

    mainSubmitFunction(_projectName, _projectDetails, _contributors);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ConstValues.PADDING),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                maxLines: 1,
                style: TextStyle(color: Colors.black),
                cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                validator: (value) {
                  if (value!.isEmpty) {
                    return Dialogs.EMPTY_FIELD;
                  }
                  return null;
                },
                key: ValueKey('Project Name'),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
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
                  _projectName = value as String;
                },
              ),
            ),
            SizedBox(
              height: ConstValues.VALUE_16,
            ),
            Container(
              child: TextFormField(
                maxLines: 5,
                // more height space to write
                style: TextStyle(color: ConstColors.APP_FONT_COLOR),
                cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                validator: (value) {
                  if (value!.isEmpty) {
                    return Dialogs.EMPTY_FIELD;
                  }
                  return null;
                },
                key: ValueKey('Project Details'),
                decoration: InputDecoration(
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
                  _projectDetails = value as String;
                },
              ),
            ),
            SizedBox(
              height: ConstValues.VALUE_16,
            ),

            // CODE TO SELECT CONTRIBUTORS
            ContributorDropdownWidget(_contributors),

            SizedBox(
              height: ConstValues.VALUE_16,
            ),
          ],
        ),
      ),
    );
  }
}
