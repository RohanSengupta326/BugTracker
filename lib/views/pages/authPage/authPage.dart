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
  RxBool isPasswordVisible = false.obs;
  RxBool _isLogin = false.obs;
  RxBool isActiveSubmitButton = false.obs;

  XFile? _pickedImage; // picked user profile pic

  void isValidDetails() {
    final isValid = _formKey.currentState!.validate();
    isValid ? isActiveSubmitButton.value = true : false;
  }

  void onSubmitted() {
    FocusScope.of(Get.context!).unfocus();

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

  void imagePicker(XFile? image) {
    _pickedImage = image; // storing picked image in variable
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                  onChanged: isValidDetails,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    //dont take as much space as possible but as minimum as needed
                    children: <Widget>[
                      if (!_isLogin.value)
                        // registering user so upload image section else not
                        UploadImage(imagePicker),
                      const SizedBox(height: ConstValues.VALUE_16),
                      SizedBox(
                        child: TextFormField(
                          style: const TextStyle(
                            color: ConstColors.APP_FONT_COLOR,
                            fontSize: 14,
                          ),
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
                            contentPadding: const EdgeInsets.only(
                                left: 16, top: 14, bottom: 14, right: 16),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            isDense: true,
                            // to size the textformfield dont use sizedBox, use contentpadding to give padding to top and bottom and isDense: true,
                            // by default its false, it means textformfield should take smaller space than default

                            focusColor: ConstColors.PRIMARY_SWATCH_COLOR,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            hintText: 'youremail@gmail.com',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                          onSaved: (value) {
                            _userEmail = value as String;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      if (!_isLogin.value)
                        Container(
                          child: TextFormField(
                            style: const TextStyle(
                              color: ConstColors.APP_FONT_COLOR,
                              fontSize: 14,
                            ),
                            cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return Dialogs.WRONG_USERNAME;
                              }

                              return null;
                            },
                            key: const ValueKey('Name'),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 16, top: 14, bottom: 14, right: 16),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              isDense: true,
                              focusColor: ConstColors.PRIMARY_SWATCH_COLOR,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              hintText: 'Your Name',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                            ),
                            onSaved: (value) {
                              _userName = value as String;
                            },
                          ),
                        ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: TextFormField(
                          style: const TextStyle(
                              color: ConstColors.APP_FONT_COLOR, fontSize: 14),
                          cursorColor: ConstColors.PRIMARY_SWATCH_COLOR,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return Dialogs.WRONG_PASSWORD_STRUCT;
                            }
                            return null;
                          },
                          key: const ValueKey('password'),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                isPasswordVisible.value =
                                    !isPasswordVisible.value;
                              },
                              icon: isPasswordVisible.value
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 16, top: 14, bottom: 14, right: 16),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusColor: ConstColors.PRIMARY_SWATCH_COLOR,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            isDense: true,
                            hintText: 'Password (min. 7 characters)',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                          obscureText: !isPasswordVisible.value,
                          onSaved: (value) {
                            _userPassword = value as String;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: ConstValues.PADDING * 2,
                      ),
                      if (controller.isLoadingAuth.value == true)
                        const CircularProgressIndicator(
                          color: ConstColors.PRIMARY_SWATCH_COLOR,
                        ),
                      if (controller.isLoadingAuth.value == false)
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              isActiveSubmitButton.value ? onSubmitted() : null;
                            },
                            style: ButtonStyle(
                              elevation: const MaterialStatePropertyAll(0),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              backgroundColor: MaterialStatePropertyAll(
                                  isActiveSubmitButton.value
                                      ? ConstColors.PRIMARY_SWATCH_COLOR
                                      : Colors.grey.shade200),
                            ),
                            child: Text(
                              _isLogin.value ? 'LogIn' : 'SignUp',
                              style: isActiveSubmitButton.value
                                  ? TextStyle(color: Colors.white)
                                  : TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 25,
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
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
