import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../components/z_button_outlined.dart';
import '../components/z_button_raised.dart';

class ZGetUtils {
  static showSnackbarSuccess(
      {@required String message,
      Duration duration,
      snackPosition: SnackPosition.BOTTOM}) {
    Get.snackbar(
      'Success!',
      '',
      messageText: Text(message,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      backgroundColor: Color(0xFFa29bfe),
      colorText: Colors.white,
      isDismissible: false,
      duration: duration ?? null,
    );
  }

  static showSnackbarError(
      {@required String message,
      Duration duration,
      snackPosition: SnackPosition.BOTTOM}) {
    print('here');
    Get.snackbar(
      'Oops!',
      '',
      messageText: Text(message,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      backgroundColor: Color(0xFFff7675),
      colorText: Colors.white,
      duration: duration ?? null,
    );
  }

  static showLoadingOverlay() {
    Get.generalDialog(
      pageBuilder: (context, animation, anotherAnimation) => Center(
        child: SpinKitRipple(color: Colors.orange, size: 130),
      ),
      barrierColor: Colors.black.withOpacity(0.4),
    );
  }

  static closeLoadingOverlay() {
    if (Get.isDialogOpen) Get.back();
    // if (Get.isDialogOpen) Get.back();
    // if (Get.isDialogOpen) Get.back();
  }

  static showDialogConfirm({
    String text,
    String onConfirmText,
    String onCancelText,
    GestureTapCallback onConfirmPressed,
    GestureTapCallback onCancelPressed,
    bool isDimissible,
  }) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Image.asset('assets/images/confirm_dialog.png', height: 120),
            SizedBox(height: 25),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(text ?? 'Are you sure you want to proceed?',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                ZButtonOutlined(
                    text: onCancelText ?? 'Cancel',
                    onTap: () {
                      if (onCancelPressed != null) onCancelPressed();
                      Get.back();
                    },
                    width: Get.width * .4,
                    height: 38),
                ZButtonRaised(
                    text: onConfirmText ?? 'Confirm',
                    onTap: () {
                      if (onConfirmPressed != null) onConfirmPressed();
                      Get.back();
                    },
                    width: Get.width * .4,
                    height: 38),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      isDismissible: isDimissible ?? true,
    );
  }
}
