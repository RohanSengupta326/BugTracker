import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/views/pages/homepage/homepage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // initializing firebase
  runApp(
    const MyApp(), // Wrap your app
  );
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
