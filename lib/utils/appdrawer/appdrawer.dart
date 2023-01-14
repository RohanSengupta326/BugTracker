import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';

import 'package:flutter/material.dart';

import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  final String developerInstaUrl = 'https://www.instagram.com/rohaaansen/';
  final String developerTwitterUrl = 'https://twitter.com/rohan_sen132';
  final String developerLinkedInUrl =
      'https://www.linkedin.com/in/rohan-sengupta-193bb916a/';

  Future<void> _launchUrl(String uri, String appPackageName) async {
    final Uri url = Uri.parse(uri);

    bool isInstalled = await DeviceApps.isAppInstalled(appPackageName);

    if (isInstalled) {
      AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data: url.toString(),
      );
      await intent.launch();
    } else {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        // to open in youtube
      )) {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: ConstColors.APP_COLOR,
                child: Padding(
                  padding: const EdgeInsets.all(ConstValues.PADDING),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: ConstValues.MARGIN),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "User",
                            style: TextStyle(
                                color: ConstColors.APPBAR_FONT_COLOR,
                                fontSize: ConstValues.FONT_SIZE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: ConstValues.PADDING),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: ConstValues.PADDING),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.dashboard,
                          color: ConstColors.PRIMARY_SWATCH_COLOR,
                        ),
                        label: const Text(
                          'DashBoard',
                          style: TextStyle(
                              fontSize: ConstValues.FONT_SIZE,
                              color: ConstColors.APP_FONT_COLOR),
                        ),
                      ),
                    ),
                    Divider(),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('LogOut'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: ConstValues.MARGIN,
                bottom: ConstValues.MARGIN / 2,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Created By Rohan Sengupta',
                  style: TextStyle(color: ConstColors.APP_FONT_COLOR),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () =>
                        _launchUrl(developerInstaUrl, 'com.instagram.android'),
                    icon: FaIcon(FontAwesomeIcons.instagram),
                  ),
                  IconButton(
                    onPressed: () =>
                        _launchUrl(developerTwitterUrl, 'com.twitter.android'),
                    icon: FaIcon(FontAwesomeIcons.twitter),
                  ),
                  IconButton(
                    onPressed: () => _launchUrl(
                        developerLinkedInUrl, 'com.linkedin.android'),
                    icon: FaIcon(FontAwesomeIcons.linkedin),
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
