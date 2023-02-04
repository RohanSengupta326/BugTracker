import 'dart:developer';

import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/authUserController/authUserController.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:bug_tracker/views/widgets/alertBoxWidget/alertBoxWidget.dart';
import 'package:bug_tracker/views/widgets/uploadPhoto/uploadPhoto.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final controller = Get.put(AuthUserController());
  final GlobalKey<FormState> _formKey = GlobalKey();

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  RxBool _isLogin = false.obs;

  XFile? _pickedImage; // picked user profile pic

  void onSubmitted() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(Get.context!).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      if (_pickedImage == null && !_isLogin.value) {
        // not registered user and also user dp picked null then alert user
        showDialog(
          context: Get.context!,
          builder: (_) {
            return AlertBoxWidget(Dialogs.UPLOAD_IMAGE_REQUEST);
          },
        );
      } else {
        // picked image not null
        XFile? userDp;
        if (!_isLogin.value) {
          // if not logging in store picked image else send null image if phone no login
          userDp = _pickedImage as XFile;
        }
        controller
            .authUser(
                _userEmail.trim(),
                _userName.trim(),
                _userPassword.trim(),
                _isLogin.value,
                userDp) // calling provider function to sign user in
            .catchError(
          (error) {
            showDialog(
              context: Get.context!,
              builder: (_) {
                return AlertBoxWidget(error);
              },
            );
          },
        );
      }
    }
  }

  void imagePicker(XFile? image) {
    _pickedImage = image; // storing picked image in variable
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: ConstValues.VALUE_16, right: ConstValues.VALUE_16),
          child: Obx(() {
            return Column(
              children: [
                // design
                const SizedBox(
                  height: ConstValues.VALUE_40,
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: ConstValues.VALUE_16),
                    child: const Text(
                      'Welcome to ',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: ConstColors.APP_FONT_COLOR,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: ConstValues.VALUE_16 / 2),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: ConstValues.VALUE_16),
                    child: const Text(
                      'BugTracker',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: ConstColors.APP_FONT_COLOR,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: ConstValues.VALUE_16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //dont take as much space as possible but as minimum as needed
                      children: <Widget>[
                        if (!_isLogin.value)
                          // registering user so upload image section else not
                          UploadImage(imagePicker),
                        const SizedBox(height: ConstValues.VALUE_16),
                        Container(
                          child: TextFormField(
                            style: const TextStyle(
                                color: ConstColors.APP_FONT_COLOR),
                            cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return Dialogs.INVALID_EMAIL;
                              }
                              return null;
                            },
                            key: const ValueKey('email'),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: ConstColors.PRIMARY_SWATCH_COLOR),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: ConstColors.PRIMARY_SWATCH_COLOR,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
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
                              hintText: 'Email',
                              hintStyle: const TextStyle(
                                color: ConstColors.HINT_COLOR,
                              ),
                            ),
                            onSaved: (value) {
                              _userEmail = value as String;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: ConstValues.VALUE_16,
                        ),
                        if (!_isLogin.value)
                          Container(
                            child: TextFormField(
                              style: const TextStyle(
                                  color: ConstColors.APP_FONT_COLOR),
                              cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 4) {
                                  return Dialogs.WRONG_USERNAME;
                                }

                                return null;
                              },
                              key: const ValueKey('Name'),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: ConstColors.PRIMARY_SWATCH_COLOR),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: ConstColors.PRIMARY_SWATCH_COLOR,
                                  ),
                                ),
                                focusColor: ConstColors.PRIMARY_SWATCH_COLOR,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: ConstColors.PRIMARY_SWATCH_COLOR,
                                  ),
                                ),
                                hintText: 'Name',
                                hintStyle: const TextStyle(
                                  color: ConstColors.HINT_COLOR,
                                ),
                              ),
                              onSaved: (value) {
                                _userName = value as String;
                              },
                            ),
                          ),
                        const SizedBox(
                          height: ConstValues.VALUE_16,
                        ),
                        Container(
                          child: TextFormField(
                            style: const TextStyle(
                                color: ConstColors.APP_FONT_COLOR),
                            cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return Dialogs.WRONG_PASSWORD_STRUCT;
                              }
                              return null;
                            },
                            key: const ValueKey('password'),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: ConstColors.PRIMARY_SWATCH_COLOR),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: ConstColors.PRIMARY_SWATCH_COLOR,
                                ),
                              ),
                              focusColor: ConstColors.PRIMARY_SWATCH_COLOR,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: ConstColors.PRIMARY_SWATCH_COLOR,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                color: ConstColors.HINT_COLOR,
                              ),
                            ),
                            obscureText: false,
                            onSaved: (value) {
                              _userPassword = value as String;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: ConstValues.VALUE_50,
                        ),
                        if (controller.isLoadingAuth.value == true)
                          const CircularProgressIndicator(
                            color: ConstColors.PRIMARY_SWATCH_COLOR,
                          ),
                        if (controller.isLoadingAuth.value == false)
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () => onSubmitted(),
                              style: ButtonStyle(
                                shadowColor: const MaterialStatePropertyAll(
                                    ConstColors.PRIMARY_SWATCH_COLOR),
                                elevation: const MaterialStatePropertyAll(
                                    ConstValues.VALUE_16 / 2),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ConstValues.BORDER_CURVE_RADIUS),
                                  ),
                                ),
                                backgroundColor: const MaterialStatePropertyAll(
                                    ConstColors.PRIMARY_SWATCH_COLOR),
                              ),
                              child: Text(_isLogin.value ? 'LogIn' : 'SignUp'),
                            ),
                          ),
                        const SizedBox(
                          height: ConstValues.VALUE_16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin.value
                                  ? 'Dont\'t have an account ? '
                                  : 'Already have an account ?',
                              style: const TextStyle(
                                  color: ConstColors.APP_FONT_COLOR),
                            ),
                            TextButton(
                              style: const ButtonStyle(
                                foregroundColor: MaterialStatePropertyAll(
                                    ConstColors.PRIMARY_SWATCH_COLOR),
                              ),
                              onPressed: () {
                                _isLogin.value = !_isLogin.value;
                                log(_isLogin.value.toString());
                              },
                              child: Text(
                                _isLogin.value ? 'Register' : 'LogIn',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: ConstValues.VALUE_16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
