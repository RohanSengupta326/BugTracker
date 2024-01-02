import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../consts/const_colors/constColors.dart';
import '../../../consts/const_values/ConstValues.dart';

class BlankLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: CupertinoActivityIndicator(
          color: Colors.white,
        ),
        backgroundColor: ConstColors.APPBAR_BACKGROUND_COLOR,
        title: const Text(
          "Projects",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: ConstColors.APPBAR_FONT_COLOR),
        ),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
