import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/views/pages/homepage/homepage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bug Tracker',
      theme: ThemeData(
        primarySwatch: ConstColors.PRIMARY_SWATCH_COLOR,
      ),
      home: HomePage(),
    );
  }
}
