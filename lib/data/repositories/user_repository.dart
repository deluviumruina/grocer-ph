import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/data/repositories/authentication_repository.dart';
import 'package:grocer_ph/features/authentication/models/user_model.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // # -------------- [GET] -------------- # 
  Future<UserModel> getUserDetails() async {
    try {
      final documentSnapshot = await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }

    } catch (e) {
      throw e.toString();
    }
  }

  // # -------------- [POST] -------------- # 
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
      
    } catch (e) {
      throw e.toString();
    }
  }

  // # -------------- [UPDATE] -------------- # 
  Future<void> updateFromPriceReport() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;

      await _db.collection('Users').doc(userId).set({
        'PriceReports': FieldValue.increment(1),
        'Reputation': FieldValue.increment(1)
      }, SetOptions(merge: true));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> toggleLike(PriceReportModel priceReport, bool isLiked) async {
    try {
      if (isLiked) {
        await _db.collection('Users').doc(priceReport.userId).set({
          'Reputation': FieldValue.increment(1)
        }, SetOptions(merge: true));
      } else {
        await _db.collection('Users').doc(priceReport.userId).set({
          'Reputation': FieldValue.increment(-1)
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw e.toString();
    }
  }
}