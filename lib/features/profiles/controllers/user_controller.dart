import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/data/repositories/authentication_repository.dart';
import 'package:grocer_ph/data/repositories/user_repository.dart';
import 'package:grocer_ph/features/authentication/models/user_model.dart';
import 'package:grocer_ph/features/authentication/screens/login_screen.dart';
import 'package:grocer_ph/features/profiles/screens/widgets/re_auth_form.dart';
import 'package:grocer_ph/utils/constants/images.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/loader_fullscreen.dart';
import 'package:grocer_ph/utils/loaders/loader_results.dart';
import 'package:grocer_ph/utils/network_manager.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  /// -- [INIT]
  final userRepository = Get.put(UserRepository());
  Rx<UserModel> user = UserModel.empty().obs;

  /// -- [DELETE]
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  // # -------------- [FORMATTING] Quantities -------------- # 
  /// -- Format PRICE REPORT TOTAL
  String formatPriceReportNumber(UserModel user) {
    String priceReportNumber;

    if (user.priceReports == 1) {
      priceReportNumber = '1 price report';
    } else {
      priceReportNumber = '${user.priceReports.toString()} reports';
    }

    return priceReportNumber;
  }
  
  // # -------------- [GET] -------------- # 
  Future<void> getUserDetails() async {
    try {
      final user = await userRepository.getUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    }
  }

  // # -------------- [LOGOUT] -------------- # 
  Future<void> logoutUser() async {
    try {
      await AuthenticationRepository.instance.logout();
    } catch (e) {
      throw e.toString();
    }
  }

  // # -------------- [DELETE] -------------- # 
  /// -- Delete User Warning
  void deleteUserWarning() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(Sizes.md),
      title: 'Delete Account',
      middleText: 'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () => Get.to(() => const ReAuthForm()),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: const BorderSide(color: Colors.red)), 
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.lg),
          child: (Text('Delete')),
        )
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(), 
        child: const Text('Cancel')
      )
    );
  }

  /// -- Delete User (after reauth)
  Future<void> deleteUser() async {
    try {
      FullscreenLoader.openLoadingDialog('Processing', Images.loadingAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullscreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormKey.currentState!.validate()) {
        FullscreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticate(verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteUser();
      
      FullscreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      FullscreenLoader.stopLoading();
      AppSnackBars.warningSnackBar(title: 'Error', message: e.toString());
    }
  }
}