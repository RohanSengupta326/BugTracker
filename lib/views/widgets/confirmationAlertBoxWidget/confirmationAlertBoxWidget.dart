import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/views/pages/DetailedTabPages/detailedTabPages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationAlertBoxWidget extends StatelessWidget {
  var message;

  ConfirmationAlertBoxWidget(
    this.message,
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstColors.ALERT_BOX_BACKGROUND_COLOR,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.toString(),
            style: const TextStyle(
                color: ConstColors.APP_FONT_COLOR,
                fontWeight: FontWeight.bold,
                fontSize: ConstValues.FONT_SIZE),
          ),
          const SizedBox(
            height: ConstValues.VALUE_16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  DetailedTabPages.confirmDelete = false;
                  Get.back();
                },
                style: ButtonStyle(
                  shadowColor: MaterialStatePropertyAll(
                      ConstColors.PRIMARY_SWATCH_COLOR),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                      ConstColors.PRIMARY_SWATCH_COLOR),
                ),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  DetailedTabPages.confirmDelete = true;
                  Get.back();
                },
                style: ButtonStyle(
                  shadowColor: MaterialStatePropertyAll(
                      ConstColors.PRIMARY_SWATCH_COLOR),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  backgroundColor:
                      MaterialStatePropertyAll(ConstColors.ERROR_COLOR),
                ),
                child: Text('Ok'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
