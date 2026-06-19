import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class AppSnackBars {
  static void hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  // ignore: strict_top_level_inference
  static void successSnackBar({required title, message = '', duration = 3}) {
    Get.snackbar(
      title, 
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: AppColors.primary,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: const Icon(Iconsax.check, color: Colors.white,)
    );
  }

  // ignore: strict_top_level_inference
  static void warningSnackBar({required title, message = '', duration = 3}) {
    Get.snackbar(
      title, 
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: AppColors.warning,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: Colors.white)

    );
  }

  // ignore: strict_top_level_inference
  static void errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      title, 
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: AppColors.error,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: Colors.white,)
    );
  }

  // ignore: strict_top_level_inference
  static void customToast({required message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: HelperFunctions.isDarkMode(Get.context!) ? AppColors.darkerGrey.withValues(alpha: 0.9) : AppColors.grey.withValues(alpha: 0.9)
          ),
          child: Center(child: Text(message, style: Theme.of(Get.context!).textTheme.labelLarge))
        )
      )
    );
  }
}
