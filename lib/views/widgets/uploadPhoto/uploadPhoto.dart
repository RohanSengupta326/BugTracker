import 'package:bug_tracker/consts/const_colors/constColors.dart';
import 'package:bug_tracker/consts/const_values/ConstValues.dart';
import 'package:bug_tracker/controllers/authUserController/authUserController.dart';
import 'package:bug_tracker/views/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadImage extends StatefulWidget {
  final void Function(XFile? image) imagePicker;
  UploadImage(this.imagePicker);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final AuthUserController controller = Get.find();
  XFile? _pickedImage;

  void uplaodImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? dp = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(
      () {
        _pickedImage = dp;
      },
    );
    widget.imagePicker(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: ConstValues.CURVE_30,
          backgroundImage: _pickedImage != null
              ? FileImage(
                  // image provider type : File
                  File(_pickedImage!.path),
                )
              : controller.currentUserData.isNotEmpty &&
                      controller.currentUserData[0].dpUrl != ''
                  ? NetworkImage(controller.currentUserData[0].dpUrl)
                  : const AssetImage('assets/images/userdp.jpg')
                      as ImageProvider<Object>,
        ),
        TextButton.icon(
          onPressed: uplaodImage,
          icon:
              const Icon(Icons.image, color: ConstColors.PRIMARY_SWATCH_COLOR),
          label: const Text(Dialogs.UPLOAD_IMAGE_REQUEST,
              style: TextStyle(color: ConstColors.PRIMARY_SWATCH_COLOR)),
        ),
      ],
    );
  }
}
