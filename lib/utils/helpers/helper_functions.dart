import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelperFunctions {

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static double screenHeight () {
    return MediaQuery.of(Get.context!).size.width;
  }

  static double screenWidth () {
    return MediaQuery.of(Get.context!).size.width;
  }

}