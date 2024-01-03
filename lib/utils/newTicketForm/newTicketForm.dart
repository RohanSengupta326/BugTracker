import 'dart:developer';

import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/projectController/projectController.dart';
import 'package:bug_tracker/utils/ticketStatusDropdown/ticketStatusDropdown.dart';
import '../TicketpriorityDropDown/ticketPriorityDropDown.dart';
import 'package:bug_tracker/utils/projectTicketTab/projectTicketTab.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:bug_tracker/views/widgets/alertBoxWidget/alertBoxWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewTicketForm extends StatelessWidget {
  static String ticketTitle = "";
  static String ticketDesc = "";

  static String priorityTicket = "";
  static String statusTicket = "";

  final ProjectsController controller = Get.find();

  final fetchedProjectid;
  final BuildContext ctx;
  final bool isEdit;
  final int? ticketIndex;
  NewTicketForm(this.fetchedProjectid, this.ctx, this.ticketIndex,
      {this.isEdit = false}) {
    //

    int projectIndex = controller.projects
        .indexWhere((element) => element.projectId == fetchedProjectid);

    if (isEdit) {
      log('-- EDIT  --');

      ticketTitle = controller
          .projects[projectIndex].ticketDetails[ticketIndex!].ticketTitle;
      ticketDesc = controller
          .projects[projectIndex].ticketDetails[ticketIndex!].ticketDesc;
      priorityTicket = controller
          .projects[projectIndex].ticketDetails[ticketIndex!].ticketPriority;
      statusTicket = controller
          .projects[projectIndex].ticketDetails[ticketIndex!].ticketStatus;
    }
  }

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  /* 
  If you declared the GlobalKey<FormState> as non-static and you have multiple instances of the same widget,
  it will create a new instance of the key every time the widget is created. This can cause unexpected 
  behavior, such as the keyboard popping back down when you try to submit a form in a TextFormField.

  By making the key static, there will only be one instance of the key across all instances of the widget,
  ensuring that the state of the form is properly maintained. This can help prevent issues like the 
  keyboard popping back down when you submit a form.
   */

  void onSubmit() async {
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();

      if (isEdit) {
        await controller
            .editTicketDetails(fetchedProjectid, ticketTitle, ticketDesc,
                priorityTicket, statusTicket, ticketIndex!)
            .catchError((error) {
          return showDialog(
            context: ctx,
            builder: (_) {
              return AlertBoxWidget(Dialogs.GENERIC_ERROR_MESSAGE);
            },
          );
        });
      } else {
        await controller
            .saveTicketDetails(fetchedProjectid, ticketTitle, ticketDesc,
                priorityTicket, statusTicket)
            .catchError((error) {
          return showDialog(
            context: ctx,
            builder: (_) {
              return AlertBoxWidget(Dialogs.GENERIC_ERROR_MESSAGE);
            },
          );
        });
      }

      Navigator.of(Get.context!).pop();
    }
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Add-Edit Tickets',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(
                  () {
                    return Align(
                      alignment: Alignment.topRight,
                      child: controller.isTickeSaving.value ||
                              controller.isTicketEditing.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: (() {
                                // submit button logic
                                onSubmit();
                              }),
                              child: Text('Submit'),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.green),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                            ),
                    );
                  },
                )
              ],
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
                  // Theres a default TextFormField Size with no attributes mentioned.
                  // wrapping TextFormField with SizedBox/container : if container height is smaller than default formfield height its bound to follow
                  // container height, but if container is bigger it wont follow container height, it will stick to its default height.

                  // then with maxLines=2, so textformfield want to show 2 lines at once, normally formfield would resize but here sizedbox predefined the
                  // height so it cant. (if container height is smaller mentioned than the default formfield height)
                  // and contentPadding simply gaps between text & border .
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      maxLines: 2,

                      initialValue: ticketTitle,
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
                        contentPadding: EdgeInsets.all(4),
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
                        ticketTitle = value as String;
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
                  TextFormField(
                    initialValue: ticketDesc,
                    //when user is typing how many previous lines above will be shown is set by max lines
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
                      // gaps between text & border.
                      contentPadding: EdgeInsets.all(4),
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
                      hintStyle: TextStyle(
                        color: ConstColors.HINT_COLOR,
                      ),
                    ),
                    onSaved: (value) {
                      ticketDesc = value as String;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'Priority',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'Status',
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(flex: 2, child: TicketPriorityDropDown()),
                      Flexible(flex: 2, child: TicketStatusDropDown()),
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
