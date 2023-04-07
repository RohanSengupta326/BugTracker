import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/views/pages/authPage/authPage.dart';
import 'package:bug_tracker/views/pages/homepage/homepage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ),
  );

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
      // for device_preview package next 3 lines
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      debugShowCheckedModeBanner: false,
      title: 'Bug Tracker',
      theme: ThemeData(
        primarySwatch: ConstColors.PRIMARY_SWATCH_COLOR,
      ),
      home: DevicePreview(
        builder: (context) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              } else {
                return AuthPage();
              }
            }),
          );
        },
      ),
    );
  }
}
