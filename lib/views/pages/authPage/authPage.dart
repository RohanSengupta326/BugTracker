import 'dart:developer' as developer;

import '../../../consts/const_colors/constColors.dart';
import '../../../controllers/authUserController/authUserController.dart';
import '../../../views/dialogs/dialogs.dart';
import '../../../views/widgets/alertBoxWidget/alertBoxWidget.dart';
import '../../../views/widgets/uploadPhoto/uploadPhoto.dart';

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

  double responsiveFontSize = Get.width * 0.04;

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

  void googleUserSignUP(BuildContext ctx) async {
    controller.googleUserSignUp().catchError((error) {
      showDialog(
        context: ctx,
        builder: (_) {
          return AlertBoxWidget(error);
        },
      );
    });
  }

  void onSubmitted() async {
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
              SizedBox(
                height: 50,
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: Get.width * 0.03),
                  child: Text(
                    'Welcome to ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: ConstColors.APP_FONT_COLOR,
                        fontSize: Get.width * 0.06,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: Get.width * 0.03),
                  child: Text(
                    'Bug Tracker',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: ConstColors.APP_FONT_COLOR,
                        fontSize: Get.width * 0.08,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 25),

              Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
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
                      TextFormField(
                        style: TextStyle(
                          fontSize: responsiveFontSize,
                          color: ConstColors.APP_FONT_COLOR,
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
                          contentPadding: EdgeInsets.only(
                              left: Get.width * 0.04,
                              top: 15,
                              bottom: 15,
                              right: Get.width * 0.04),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.blue),
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
                              color: Colors.blue,
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
                            fontSize: responsiveFontSize,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        onSaved: (value) {
                          _userEmail = value as String;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (!_isLogin.value)
                        TextFormField(
                          style: TextStyle(
                            fontSize: responsiveFontSize,
                            color: ConstColors.APP_FONT_COLOR,
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
                            contentPadding: EdgeInsets.only(
                                left: Get.width * 0.04,
                                top: 15,
                                bottom: 15,
                                right: Get.width * 0.04),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Colors.blue),
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
                                color: Colors.blue,
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
                              fontSize: responsiveFontSize,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          onSaved: (value) {
                            _userName = value as String;
                          },
                        ),
                      SizedBox(
                        height: _isLogin.value ? 0 : 5,
                      ),
                      TextFormField(
                        style: TextStyle(
                          fontSize: responsiveFontSize,
                          color: ConstColors.APP_FONT_COLOR,
                        ),
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
                          contentPadding: EdgeInsets.only(
                              left: Get.width * 0.04,
                              top: 15,
                              bottom: 15,
                              right: Get.width * 0.04),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.blue),
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
                              color: Colors.blue,
                            ),
                          ),
                          isDense: true,
                          hintText: 'Password (min. 7 characters)',
                          hintStyle: TextStyle(
                            fontSize: responsiveFontSize,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        obscureText: !isPasswordVisible.value,
                        onSaved: (value) {
                          _userPassword = value as String;
                        },
                      ),
                      SizedBox(height: 15),
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
                                  ? TextStyle(
                                      fontSize: responsiveFontSize,
                                      color: Colors.white)
                                  : TextStyle(
                                      fontSize: responsiveFontSize,
                                      color: Colors.grey),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              _isLogin.value
                                  ? 'Dont\'t have an account ? '
                                  : 'Already have an account ?',
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: responsiveFontSize,
                                  color: ConstColors.APP_FONT_COLOR),
                            ),
                          ),
                          TextButton(
                            style: const ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(
                                  ConstColors.PRIMARY_SWATCH_COLOR),
                            ),
                            onPressed: () {
                              _isLogin.value = !_isLogin.value;
                              developer.log(_isLogin.value.toString());
                            },
                            child: Text(
                              _isLogin.value ? 'Register' : 'LogIn',
                              style: TextStyle(fontSize: responsiveFontSize),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Divider(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.01),
                            child: Text(
                              "or",
                              style: TextStyle(
                                  fontSize: responsiveFontSize,
                                  color: Colors.grey.shade400),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Divider(color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      controller.isGoogleLoadingAuth.value
                          ? SizedBox(
                              height: 20,
                              width: Get.width * 0.06,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ))
                          : Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(25)),
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // functio to call google signup
                                  googleUserSignUP(context);
                                },
                                style: ButtonStyle(
                                  elevation: const MaterialStatePropertyAll(0),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.white),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: Get.width * 0.02),
                                          child: Image.asset(
                                            'assets/images/google_sign_in.png',
                                            height: 18,
                                            width: 18,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Sign Up with Google',
                                        style: TextStyle(
                                          fontSize: responsiveFontSize,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 10,
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
