import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:flutter/material.dart';

class AlertBoxWidget extends StatelessWidget {
  dynamic error;
  AlertBoxWidget(this.error);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ConstColors.ALERT_BOX_BACKGROUND_COLOR,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            error.toString(),
            style: const TextStyle(
                color: ConstColors.APP_FONT_COLOR,
                fontWeight: FontWeight.bold,
                fontSize: ConstValues.FONT_SIZE),
          ),
          const SizedBox(
            height: ConstValues.VALUE_16,
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              shadowColor:
                  MaterialStatePropertyAll(ConstColors.PRIMARY_SWATCH_COLOR),
              elevation: MaterialStatePropertyAll(ConstValues.VALUE_16),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              backgroundColor:
                  MaterialStatePropertyAll(ConstColors.PRIMARY_SWATCH_COLOR),
            ),
            child: Text('Ok!'),
          ),
        ],
      ),
    );
  }
}
