import 'package:get/get.dart';
import 'package:grocer_ph/data/repositories/authentication_repository.dart';
import 'package:grocer_ph/data/repositories/user_repository.dart';
import 'package:grocer_ph/features/authentication/models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

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
      profileLoading.value = true;
      final user = await userRepository.getUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
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
}