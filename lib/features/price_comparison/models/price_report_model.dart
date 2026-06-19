import 'package:cloud_firestore/cloud_firestore.dart';

class PriceReportModel {
  String id;
  double price;
  DateTime date;
  String productId;
  String productName;
  String? productImage;
  String storeId;
  String storeName;
  String storeLocation;
  String userId;
  String userName;
  int? confirmations;
  List<dynamic>? confirmationsList;

  PriceReportModel({
    required this.id,
    required this.price,
    required this.date,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.storeId,
    required this.storeName,
    required this.storeLocation,
    required this.userId,
    required this.userName,
    this.confirmations = 0,
    this.confirmationsList
  });

  /// -- Empty
  static PriceReportModel empty() => PriceReportModel(id: '', price: 0.0, date: DateTime.fromMillisecondsSinceEpoch(0), productId: '', productName: '', storeId: '', storeName: '', storeLocation: '', userId: '', userName: '');

  /// -- Model -> Firebase(JSON)
  // ignore: strict_top_level_inference
  toJson() {
    return {
      'Price': price,
      'Date': date,
      'ProductId': productId,
      'ProductName': productName,
      'ProductImage': productImage,
      'StoreId': storeId,
      'StoreName': storeName,
      'StoreLocation': storeLocation,
      'UserId': userId,
      'UserName': userName,
      'Confirmations': confirmations,
      'ConfirmationsList': confirmationsList
    };
  }

  /// -- Firebase(JSON) -> Model
  factory PriceReportModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return PriceReportModel(
        id: document.id, 
        price: data['Price'], 
        date: data['Date'].toDate(), 
        productId: data['ProductId'],
        productName: data['ProductName'],
        productImage: data['ProductImage'],
        storeId: data['StoreId'],
        storeName: data['StoreName'],
        storeLocation: data['StoreLocation'],
        userId: data['UserId'],
        userName: data['UserName'],
        confirmations: data['Confirmations'],
        confirmationsList: data['ConfirmationsList']
      );
    } else {
      return PriceReportModel.empty();
    }
  }

  factory PriceReportModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return PriceReportModel(
        id: document.id, 
        price: data['Price'], 
        date: data['Date'].toDate(), 
        productId: data['ProductId'],
        productName: data['ProductName'],
        productImage: data['ProductImage'],
        storeId: data['StoreId'],
        storeName: data['StoreName'],
        storeLocation: data['StoreLocation'],
        userId: data['UserId'],
        userName: data['UserName'],
        confirmations: data['Confirmations'],
        confirmationsList: data['ConfirmationsList']
      );
    }
}