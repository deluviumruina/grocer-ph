import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/data/repositories/authentication_repository.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';

class PriceReportRepository extends GetxController {
  static PriceReportRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  
  // # -------------- BACKEND [Get] -------------- #
  /// -- Get PRODUCT (limited) price reports
  Future<List<PriceReportModel>> getLimitedProductPriceReports(String productId) async {
    try {
      final query = await _db.collection('PriceReports')
        .where('ProductId', isEqualTo: productId)
        .orderBy('Confirmations', descending: true)
        .orderBy('Date', descending: true)
        .limit(5)
        .get();
      return query.docs.map((snapshot) => PriceReportModel.fromSnapshot(snapshot)).toList(); 
    } catch (e) {
      throw e.toString();
    }
  }
  
  /// -- Get PRODUCT (all) price reports, initial
  Future<QuerySnapshot> getFirstAllProductPriceReports(String productId, int limit) async {
    try {
      final query = await _db.collection('PriceReports')
        .where('ProductId', isEqualTo: productId)
        .orderBy('Confirmations', descending: true)
        .orderBy('Date', descending: true)
        .limit(limit)
        .get();
      return query; 
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get PRODUCT (all) price reports, additional
  Future<QuerySnapshot> getMoreAllProductPriceReports(String productId, DocumentSnapshot lastDocument, int limit) async {
    try {
      final query = await _db.collection('PriceReports')
        .where('ProductId', isEqualTo: productId)
        .orderBy('Confirmations', descending: true)
        .orderBy('Date', descending: true)
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();
      return query; 
    } catch (e) {
      throw e.toString();
    }
  }

  /// -- Get PRODUCT price reports for a specific STORE
  Future<List<PriceReportModel>> getStoreProductPriceReports(String productId, String storeId) async {
    try {
      final query = await _db.collection('PriceReports')
        .where('ProductId', isEqualTo: productId)
        .where('StoreId', isEqualTo: storeId)
        .orderBy('Confirmations', descending: true)
        .orderBy('Date', descending: true)
        .get();
      return query.docs.map((snapshot) => PriceReportModel.fromSnapshot(snapshot)).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  /// Get CURRENT USER price reports, initial
  Future<QuerySnapshot> getFirstCurrentUserPriceReports(int limit) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;

      QuerySnapshot query = await _db
        .collection('PriceReports')
        .where('UserId', isEqualTo: userId)
        .orderBy('Date', descending: true)
        .limit(limit)
        .get();

        return query;
    } catch (e) {
      throw e.toString();
    }
  }

  /// Get CURRENT USER price reports, additional
  Future<QuerySnapshot> getMoreCurrentUserPriceReports(DocumentSnapshot lastDocument, int limit) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;

      QuerySnapshot query = await _db
        .collection('PriceReports')
        .where('UserId', isEqualTo: userId)
        .orderBy('Date', descending: true)
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();

        return query;
    } catch (e) {
      throw e.toString();
    }
  }

  // # -------------- [POST] -------------- #
  Future<void> addPriceReport(PriceReportModel priceReport) async {
    try {
      await _db.collection('PriceReports').add(priceReport.toJson());
    } catch (e) {
      throw e.toString();
    }
  }

  // # -------------- [UPDATE] -------------- #
  Future<void> toggleLike(PriceReportModel priceReport, String userId, bool isLiked) async {
    try {
      if (isLiked) {
        await _db.collection('PriceReports').doc(priceReport.id).set({
          'Confirmations': FieldValue.increment(1),
          'ConfirmationsList': FieldValue.arrayUnion([userId])
        }, SetOptions(merge: true));
      } else {
        await _db.collection('PriceReports').doc(priceReport.id).set({
          'Confirmations': FieldValue.increment(-1),
          'ConfirmationsList': FieldValue.arrayRemove([userId])
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
