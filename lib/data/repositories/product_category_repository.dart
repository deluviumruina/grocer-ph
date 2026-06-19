import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/features/products/models/product_category_model.dart';

class ProductCategoryRepository extends GetxController {
  static ProductCategoryRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// -- Get Categories
  Future<List<ProductCategoryModel>> getProductCategories() async {
    try {
      final snapshot = await _db.collection('ProductCategories').get();
      final categories = snapshot.docs.map((document) => ProductCategoryModel.fromSnapshot(document)).toList();
      return categories;
    } catch (e) {
      throw e.toString();
    }
  }
}