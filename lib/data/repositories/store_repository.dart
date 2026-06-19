import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/features/stores/models/store_model.dart';

class StoreRepository extends GetxController {
  static StoreRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /*   -------------- [GET] -------------- */
  /// -- Get ALL stores
  Future<List<StoreModel>> getAllStores() async {
    try {
      final snapshot = await _db.collection('Stores').get();
      final result = snapshot.docs.map((e) => StoreModel.fromSnapshot(e)).toList();
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get CATEGORY stores, initial
  Future<QuerySnapshot> getFirstCategoryStores(String storeCategoryId, int limit) async {
    try {
      QuerySnapshot query = await _db
        .collection('Stores')
        .where('CategoryId', isEqualTo: storeCategoryId)
        .orderBy('LastUpdated', descending: true)
        .limit(limit)
        .get();
      return query;
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get CATEGORY stores, additional
  Future<QuerySnapshot> getMoreCategoryStores(String storeCategoryId, DocumentSnapshot lastDocument, int limit) async {
    try {
      QuerySnapshot query = await _db
        .collection('Stores')
        .where('CategoryId', isEqualTo: storeCategoryId)
        .orderBy('LastUpdated', descending: true)
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();
      return query;
    } catch (e) {
      throw e.toString();
    }
  }
  
  /// -- Get PRODUCT IDS from price reports
  Future<List<String>> getStoreProductIds (String storeId) async {
    try {
      QuerySnapshot query = await _db
        .collection('PriceReports')
        .where('StoreId', isEqualTo: storeId)
        .orderBy('Date', descending: true)
        .get();
      List<String> ids = query.docs.map((doc) => doc['ProductId'] as String).toList();
      return ids;
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get SINGLE store
  Future<StoreModel> getSingleStore(String storeId) async {
    try {
      final snapshot = await _db.collection('Stores').doc(storeId).get();
      return StoreModel.fromSnapshot(snapshot);
    } catch (e) {
      throw e.toString();
    }
  }

  /*   -------------- [POST] -------------- */
  Future<void> addStore(StoreModel store) async {
    try {
      await _db.collection('Stores').add(store.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /*   -------------- [UPDATE] -------------- */
  /// -- Update price report total and date updated after adding price report
  Future<void> updateFromPriceReport(String storeId) async {
    try {
      await _db.collection('Stores').doc(storeId).set({
        'LastUpdated': DateTime.now(),
        'PriceReports': FieldValue.increment(1)
      }, SetOptions(merge: true));
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Update store details
  Future<void> updateStore(String storeId, Map<String, dynamic> updates) async {
    try {
      await _db.collection('Stores').doc(storeId).update(updates);

      DocumentSnapshot sourceDoc = await _db.collection('Stores').doc(storeId).get();
      Map<String, dynamic> sourceData = sourceDoc.data() as Map<String, dynamic>;
      
      final QuerySnapshot query = await _db.collection('PriceReports').where('StoreId', isEqualTo: storeId).get();
      for (var doc in query.docs) {
        await _db.collection('PriceReports').doc(doc.id).set({
          'StoreName': sourceData['Name'],
          'StoreLocation': sourceData['Location']
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw e.toString();
    }
  }
  
}