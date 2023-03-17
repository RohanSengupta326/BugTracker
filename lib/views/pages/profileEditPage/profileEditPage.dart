import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/controllers/authUserController/authUserController.dart';

import 'package:bug_tracker/models/currUserData/currUserData.dart';
import 'package:bug_tracker/views/pages/homepage/homepage.dart';
import 'package:bug_tracker/views/widgets/alertBoxWidget/alertBoxWidget.dart';
import 'package:bug_tracker/views/widgets/uploadPhoto/uploadPhoto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthUserController controller = Get.find();
  String _userName = '';
  XFile? _pickedImage;

  void imagePicker(XFile? image) {
    _pickedImage = image;
  }

  void onSubmitted(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      if (_pickedImage == null &&
          (controller.currentUserData.isEmpty &&
              controller.currentUserData[0].dpUrl == '')) {
        // if picked image null and was also null before then pick one now
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertBoxWidget('Couldnt upload image');
          },
        );
      } else {
        XFile? userDp;

        userDp = _pickedImage != null ? _pickedImage as XFile : null;
        // picked image can be null if previously there was some image already

        if (_userName == '' && userDp != null) {
          // selected profile picture but not new username

          _userName = controller.currentUserData[0].username == ''
              ? 'User'
              : controller.currentUserData[0].username;
          // if previously there was a username then save that else save User
        } else if (_userName == '' && userDp == null) {
          // if both are unchanged then go back dont save
          return;
        }

        await controller.saveNewUserData(_userName.trim(), userDp).catchError(
          (error) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertBoxWidget(error);
              },
            );
          },
        );

        Get.back();

        controller.fetchUserData().catchError(
          (onError) {
            print(onError);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: ConstColors.PRIMARY_SWATCH_COLOR,
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'Change/Set Profile Picture and Username',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    //dont take as much space as possible but as minimum as needed
                    children: <Widget>[
                      UploadImage(imagePicker),
                      SizedBox(height: 16),
                      Container(
                        child: TextFormField(
                          style: TextStyle(color: Colors.black),
                          cursorColor: Colors.blue,
                          key: ValueKey('username'),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            focusColor: Colors.blue,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                            hintText:
                                controller.currentUserData[0].username == ''
                                    ? 'User'
                                    : controller.currentUserData[0].username,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onSaved: (value) {
                            _userName = value as String;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      controller.isSaveUserDataLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.blue,
                            )
                          : SizedBox(
                              height: 50,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () => onSubmitted(context),
                                style: ButtonStyle(
                                  shadowColor:
                                      MaterialStatePropertyAll(Colors.blue),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue),
                                ),
                                child: Text('Save'),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
