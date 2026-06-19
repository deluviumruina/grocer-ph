import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/animations/animation_loader.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';

class FullscreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false, 
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: HelperFunctions.isDarkMode(Get.context!) ? AppColors.dark : Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(children: [
            const SizedBox(height: 250),
            GAnimationLoaderWidget(text: text, animation: animation),
          ],),
        )
      )
    );
  }

  static void stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}