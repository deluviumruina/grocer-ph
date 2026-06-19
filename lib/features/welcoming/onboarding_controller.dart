import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ph/features/authentication/screens/login_screen.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  /// Variables
  final pageController = PageController();
  var currentPageIndex = 0;
  
  /// Update Current Index when Page Scroll
  void updatePageIndicator(dynamic index) => currentPageIndex = index;

  /// Jump to the specific dot selected page
  void dotNavigationClick(dynamic index) {
    currentPageIndex= index;
    pageController.jumpTo(index);
  }

  /// Update Current Index and jump to next page; Redirect to Login Screen on last page and mark onboarding screens as viewed
  void nextPage() {
    if (currentPageIndex == 2){
      final storage = GetStorage();
      storage.write('IsFirstTime', false);
      Get.offAll(() => const LoginScreen());
    } else {
      int page = currentPageIndex + 1;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut, 
      );
    }
  }

  /// Update Current Index and jump to the last page
  void skipPage() {
    currentPageIndex = 2;
    pageController.jumpToPage(2);
  }
}