import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String name;
  String? image;
  String? description;
  String categoryId;
  DateTime lastUpdated;
  int priceReports;
  double? priceMinimum;
  double? priceMaximum;

  ProductModel({
    required this.id,
    required this.name,
    this.image,
    this.description,
    required this.categoryId,
    required this.lastUpdated,
    required this.priceReports,
    this.priceMinimum,
    this.priceMaximum,
  });

  /// -- Empty
  static ProductModel empty() => ProductModel(id: '', name: '', categoryId: '', lastUpdated: DateTime.fromMillisecondsSinceEpoch(0), priceReports: 0);

  /// -- Model -> Firebase(JSON)
  // ignore: strict_top_level_inference
  toJson() {
    return {
      'Name': name,
      'Image': image ?? '',
      'Description': description ?? '',
      'CategoryId': categoryId,
      'LastUpdated': lastUpdated,
      'PriceReports': priceReports,
      'PriceMinimum': priceMinimum ?? 0.0,
      'PriceMaximum': priceMaximum ?? 0.0
    };
  }

  /// -- Firebase(JSON) -> Model
  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if(document.data() == null) return ProductModel.empty();
    
    final data = document.data()!;
    return ProductModel(
      id: document.id,
      name: data['Name'],
      image: data['Image'] ?? '',
      description: data['Description'] ?? '',
      categoryId: data['CategoryId'],
      lastUpdated: data['LastUpdated'].toDate(),
      priceReports: data['PriceReports'],
      priceMinimum: data['PriceMinimum'] ?? 0.00,
      priceMaximum: data['PriceMaximum'] ?? 0.00
    );
  }

  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: document.id,
      name: data['Name'], 
      image: data['Image'] ?? '',
      description: data['Description'] ?? '',
      categoryId: data['CategoryId'],
      lastUpdated: data['LastUpdated'].toDate(),
      priceReports: data['PriceReports'],
      priceMinimum: data['PriceMinimum'] ?? 0.0,
      priceMaximum: data['PriceMaximum'] ?? 0.0
    );
  }

}