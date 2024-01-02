import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/authUserController/authUserController.dart';

import 'package:bug_tracker/utils/profilePictureView/profilePictureView.dart';
import 'package:bug_tracker/views/pages/homepage/homepage.dart';
import 'package:bug_tracker/views/pages/profileEditPage/profileEditPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  final String developerInstaUrl = 'https://www.instagram.com/rohaaansen/';
  final String developerTwitterUrl = 'https://twitter.com/rohan_sen132';
  final String developerLinkedInUrl =
      'https://www.linkedin.com/in/rohan-sengupta-193bb916a/';

  final AuthUserController authUserController = Get.find();
  final AuthUserController fetchAllUsersController = Get.find();

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
    // print('------------ ENTERING APP DRAWER ----------');
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
                        margin: const EdgeInsets.only(left: ConstValues.MARGIN),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Obx(() {
                            return fetchAllUsersController
                                    .isLoadingUserData.value
                                ? const CupertinoActivityIndicator(
                                    color: Colors.white,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return ProfilePictureView(
                                              fetchAllUsersController
                                                  .currentUserData[0].dpUrl);
                                        },
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: fetchAllUsersController
                                                  .currentUserData.isNotEmpty &&
                                              fetchAllUsersController
                                                      .currentUserData[0]
                                                      .dpUrl !=
                                                  ''
                                          ? NetworkImage(fetchAllUsersController
                                              .currentUserData[0].dpUrl)
                                          : const AssetImage(
                                                  'assets/images/userdp.jpg')
                                              as ImageProvider<Object>,
                                    ),
                                  );
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: ConstValues.VALUE_16,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ConstValues.MARGIN),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Obx(() {
                            return fetchAllUsersController
                                    .isLoadingUserData.value
                                ? const CupertinoActivityIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    fetchAllUsersController
                                                .currentUserData.isNotEmpty &&
                                            fetchAllUsersController
                                                    .currentUserData[0]
                                                    .username !=
                                                ''
                                        ? fetchAllUsersController
                                            .currentUserData[0].username
                                        : 'User',
                                    style: const TextStyle(
                                        fontSize: ConstValues.HEADING_FONT_SIZE,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: ConstValues.PADDING),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: ConstValues.PADDING),
                child: Column(
                  children: [
                    const Divider(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          Get.to(ProfileEditScreen());
                        },
                        icon: const Icon(
                          Icons.manage_accounts_sharp,
                          color: ConstColors.PRIMARY_SWATCH_COLOR,
                        ),
                        label: const Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: ConstValues.FONT_SIZE,
                              color: ConstColors.APP_FONT_COLOR),
                        ),
                      ),
                    ),
                    const Divider(),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              ConstColors.ERROR_COLOR)),
                      onPressed: () => authUserController.logOut(),
                      child: Text('LogOut'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: ConstValues.MARGIN,
                bottom: ConstValues.MARGIN / 2,
              ),
              child: const Align(
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
