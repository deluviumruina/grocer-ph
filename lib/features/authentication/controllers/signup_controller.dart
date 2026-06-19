import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/success_screen.dart';
import 'package:grocer_ph/data/repositories/authentication_repository.dart';
import 'package:grocer_ph/data/repositories/user_repository.dart';
import 'package:grocer_ph/features/authentication/models/user_model.dart';
import 'package:grocer_ph/utils/constants/images.dart';
import 'package:grocer_ph/utils/loaders/loader_fullscreen.dart';
import 'package:grocer_ph/utils/loaders/loader_results.dart';
import 'package:grocer_ph/utils/network_manager.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final dataConsent = true.obs;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  final hidePassword = true.obs;

  void signup() async {
    try {

      /// -- Start Loading
      FullscreenLoader.openLoadingDialog('We are processing your information...', Images.loadingAnimation);

      /// -- Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullscreenLoader.stopLoading();
        return;
      }

      /// -- Form Validation
      if(!signupFormKey.currentState!.validate()) {
        FullscreenLoader.stopLoading();
        return;
      }

      /// -- Data Consent
      if (!dataConsent.value) {
        FullscreenLoader.stopLoading();
        AppSnackBars.warningSnackBar(
          title: 'Notice',
          message: 'In order to create an account, you must consent to your app data being gathered and used for the purposes of its associated study.',
          duration: 10,
        );
        return;
      }

      /// -- Register User Account in Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      /// -- Save Authenticated User Data in Firebase
      final user = UserModel(
        id: userCredential.user!.uid, 
        username: username.text.trim(), 
        email: email.text.trim(),
        priceReports: 0,
        reputation: 0
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(user);

      FullscreenLoader.stopLoading();

      /// -- Redirect to Success Screen
      Get.off(
        () => SuccessScreen(
          image: Images.successAnimation, 
          title: 'Your account has been created!', 
          subTitle: 'Welcome to GrocerPH.', 
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        )
      );

    } catch (e) {
      FullscreenLoader.stopLoading();

      /// -- Generic Error
      AppSnackBars.errorSnackBar(title: 'Error.', message: e.toString());

    }
  }
}