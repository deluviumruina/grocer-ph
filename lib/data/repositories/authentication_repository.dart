import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ph/data/repositories/user_repository.dart';
import 'package:grocer_ph/features/authentication/screens/login_screen.dart';
import 'package:grocer_ph/features/welcoming/onboarding_screen.dart';
import 'package:grocer_ph/navigation_menu.dart';
import 'package:grocer_ph/utils/local_storage/storage_utility.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// -- Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// -- Redirect Function
  Future<void> screenRedirect() async {
    final user = _auth.currentUser;

    /// -- Checks if user is logged in.
    if(user != null) {
      await LocalStorage.init(user.uid);
      Get.offAll(() => const NavigationMenu());
    } else {

      /// -- Writes 'IsFirstTime true' to local storage.
      deviceStorage.writeIfNull('IsFirstTime', true);

      /// -- Checks if this is the first time launching the app.
      deviceStorage.read('IsFirstTime') != true 
      ? Get.offAll(() => const LoginScreen()) 
      : Get.offAll(const OnBoardingScreen());
    }
  }

/*   -------------- [SIGN IN] -------------- */

  /// -- Login
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e.toString();
    }
  }
  
  /// -- Register
  Future<UserCredential> register(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Re-Authenticate
  Future<void> reAuthenticate(String email, String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } catch (e) {
      throw e.toString();
    }
  }

/*   -------------- [SIGN OUT] -------------- */

  /// -- Logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      throw e.toString();
    }
  }

/*   -------------- [DELETE] -------------- */
  Future<void> deleteUser() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } catch (e) {
      throw e.toString();
    }
  }
}