import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ph/data/repositories/authentication_repository.dart';
import 'package:grocer_ph/utils/constants/images.dart';
import 'package:grocer_ph/utils/loaders/loader_fullscreen.dart';
import 'package:grocer_ph/utils/loaders/loader_results.dart';
import 'package:grocer_ph/utils/network_manager.dart';

class LoginController extends GetxController {
  
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final rememberMe = false.obs;
  final hidePassword = true.obs;

  @override
  void onInit() {
    if (localStorage.read('REMEMBER_ME_EMAIL') != null && localStorage.read('REMEMBER_ME_PASSWORD') != null) {
      email.text = localStorage.read('REMEMBER_ME_EMAIL');
      password.text = localStorage.read('REMEMBER_ME_PASSWORD');}
    super.onInit();
  }

  /// -- Sign In
  Future<void> emailAndPasswordSignIn() async {
    try {

      /// -- Start Loading
      FullscreenLoader.openLoadingDialog('Logging in...', Images.loadingAnimation);

      /// -- Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullscreenLoader.stopLoading();
        return;
      }

      /// -- Form Validation
      if (!loginFormKey.currentState!.validate()) {
        FullscreenLoader.stopLoading();
        return;
      }

      /// -- Save Data if 'Remember Me' is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      /// -- Login User
      await AuthenticationRepository.instance.login(email.text.trim(), password.text.trim());

      /// -- Remove Loader
      FullscreenLoader.stopLoading();

      /// -- Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      FullscreenLoader.stopLoading();
      AppSnackBars.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

}