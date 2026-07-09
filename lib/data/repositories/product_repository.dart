import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /*   -------------- [GET] -------------- */
  /// -- QUERY products, initial
  Future<QuerySnapshot<Object?>> queryFirstProducts(Query query, int limit) async {
    try {
      final querySnapshot = await query
        .limit(limit)
        .get();
      return querySnapshot;
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- QUERY products, additional
  Future<QuerySnapshot<Object?>> queryMoreProducts(Query query, DocumentSnapshot lastDocument, int limit) async {
    try {
      final querySnapshot = await query
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();
      return querySnapshot;
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get HOME products
  Future<List<ProductModel>> getHomeProducts() async {
    try {
      final snapshot = await _db
        .collection('Products')
        .orderBy('LastUpdated', descending: true)
        .limit(10)
        .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get CATEGORY Products
  Future<List<ProductModel>> getCategoryProducts(String productCategoryId) async {
    try {
      final query = await _db
          .collection('Products')
          .where('CategoryId', isEqualTo: productCategoryId)
          .orderBy('LastUpdated', descending: true)
          .get();

      List<ProductModel> products = query.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
      return products;
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get CATEGORY Products, initial
  Future<QuerySnapshot> getFirstCategoryProducts(String productCategoryId) async {
    try {
      QuerySnapshot query = await _db
        .collection('Products')
        .where('CategoryId', isEqualTo: productCategoryId)
        .orderBy('LastUpdated', descending: true)
        .limit(6)
        .get();

        return query;
    } catch (e) {
      throw e.toString();
    }
  }

  /// Get CATEGORY Products, additional
  Future<QuerySnapshot> getMoreCategoryProducts(String productCategoryId, DocumentSnapshot lastDocument) async {
    try {
      QuerySnapshot query = await _db
        .collection('Products')
        .where('CategoryId', isEqualTo: productCategoryId)
        .orderBy('LastUpdated', descending: true)
        .startAfterDocument(lastDocument)
        .limit(6)
        .get();

        return query;
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get FAVORITE products
  Future<List<ProductModel>> getFavoriteProducts(
    List<String> productIds,
  ) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();
      return snapshot.docs
          .map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot))
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get SINGLE product
  Future<ProductModel> getSingleProduct(String productId) async {
    try {
      final snapshot = await _db.collection('Products').doc(productId).get();
      return ProductModel.fromSnapshot(snapshot);
    } catch (e) {
      throw e.toString();
    }
  }

  /*   -------------- [CREATE] -------------- */
  /// -- Add product
  Future<void> addProduct(ProductModel product) async {
    try {
      await _db.collection('Products').add(product.toJson());
    } catch (e) {
      throw e.toString();
    }
  }

  /*   -------------- [UPDATE] -------------- */
  /// -- Update price report total, date updated, price minimum, price maximum, and stores after adding price report
  Future<void> updateFromPriceReport(String productId, String storeId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('PriceReports')
          .where('ProductId', isEqualTo: productId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return;
        
      } else {
        List<double> prices = querySnapshot.docs.map((doc) {
          return (doc['Price'] as num).toDouble();
        }).toList();

        double priceMinimum = prices.reduce(min);
        double priceMaximum = prices.reduce(max);

        await _db.collection('Products').doc(productId).set({
          'LastUpdated': DateTime.now(),
          'PriceReports': FieldValue.increment(1),
          'PriceMinimum': priceMinimum,
          'PriceMaximum': priceMaximum,
          'Stores': FieldValue.arrayUnion([storeId])
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Update product details
  Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      await _db.collection('Products').doc(productId).update(updates);

      DocumentSnapshot sourceDoc = await _db.collection('Products').doc(productId).get();
      Map<String, dynamic> sourceData = sourceDoc.data() as Map<String, dynamic>;
      
      final QuerySnapshot query = await _db.collection('PriceReports').where('ProductId', isEqualTo: productId).get();
      for (var doc in query.docs) {
        await _db.collection('PriceReports').doc(doc.id).set({
          'ProductName': sourceData['Name'],
          'ProductImage': sourceData['Image']
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
