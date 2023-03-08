import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/utils/TicketpriorityDropDown/ticketPriorityDropDown.dart';
import 'package:bug_tracker/utils/projectTicketTab/projectTicketTab.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTicketForm extends StatelessWidget {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  /* 
  If you declared the GlobalKey<FormState> as non-static and you have multiple instances of the same widget,
  it will create a new instance of the key every time the widget is created. This can cause unexpected 
  behavior, such as the keyboard popping back down when you try to submit a form in a TextFormField.

  By making the key static, there will only be one instance of the key across all instances of the widget,
  ensuring that the state of the form is properly maintained. This can help prevent issues like the 
  keyboard popping back down when you submit a form.
   */

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: ConstValues.PADDING,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + ConstValues.PADDING,
          left: ConstValues.PADDING,
          right: ConstValues.PADDING,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Add-Edit Tickets',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
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
                    height: 30,
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
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
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
                        hintStyle: TextStyle(
                          color: ConstColors.HINT_COLOR,
                        ),
                      ),
                      onSaved: (value) {
                        ProjectTicketTab.ticketTitle = value as String;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Description',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      maxLines: 3,
                      style: TextStyle(color: Colors.black),
                      cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Dialogs.EMPTY_FIELD;
                        }
                        return null;
                      },
                      // initialValue: NewProjectFormPage.projectName,
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
                        hintStyle: TextStyle(
                          color: ConstColors.HINT_COLOR,
                        ),
                      ),
                      onSaved: (value) {
                        ProjectTicketTab.ticketDesc = value as String;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Priority',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Status',
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(flex: 2, child: TicketPriorityDropDown()),
                      Expanded(flex: 2, child: TicketPriorityDropDown())
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
