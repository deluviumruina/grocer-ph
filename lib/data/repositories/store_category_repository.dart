import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/features/stores/models/store_category_model.dart';

class StoreCategoryRepository extends GetxController {
  static StoreCategoryRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// -- Get ALL Categories
  Future<List<StoreCategoryModel>> getallStoreCategories() async {
    try {
      
      final snapshot = await _db.collection('StoreCategories').get();
      final list = snapshot.docs.map((document) => StoreCategoryModel.fromSnapshot(document)).toList();
      return list;

    } catch (e) {
      throw e.toString();
    }
  }
}