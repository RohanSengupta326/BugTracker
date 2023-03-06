import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/utils/projectTicketTab/projectTicketTab.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:flutter/material.dart';

class NewTicketForm extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ConstValues.PADDING),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text('Add-Edit Tickets'),
            ),
            SizedBox(height: ConstValues.VALUE_50),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Title',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
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
                      // initialValue: NewProjectFormPage.projectName,
                      key: ValueKey('Ticket Title'),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: ConstColors.PRIMARY_SWATCH_COLOR),
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
                        hintText: 'ticket title',
                        hintStyle: TextStyle(
                          color: ConstColors.HINT_COLOR,
                        ),
                      ),
                      onSaved: (value) {
                        ProjectTicketTab.ticketTitle = value as String;
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
