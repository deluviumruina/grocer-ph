import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  String id;
  String name;
  String location;
  String? image;
  String categoryId;
  DateTime lastUpdated;
  int priceReports;

  StoreModel({
    required this.id,
    required this.name,
    required this.location,
    this.image,
    required this.categoryId,
    required this.lastUpdated,
    required this.priceReports,
  });

  /// -- Empty
  static StoreModel empty() => StoreModel(
    id: '',
    name: '',
    location: '',
    categoryId: '',
    lastUpdated: DateTime.fromMillisecondsSinceEpoch(0),
    priceReports: 0,
  );

  /// -- Model -> Firebase(JSON)
  // ignore: strict_top_level_inference
  toJson() {
    return {
      'Name': name,
      'Location': location,
      'Image': image,
      'CategoryId': categoryId,
      'LastUpdated': lastUpdated,
      'PriceReports': priceReports,
    };
  }

  /// -- Firebase(JSON) -> Model
  factory StoreModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;

      return StoreModel(
        id: document.id,
        name: data['Name'] ?? '',
        location: data['Location'] ?? '',
        image: data['Image'] ?? '',
        categoryId: data['CategoryId'] ?? '',
        lastUpdated: data['LastUpdated'].toDate(),
        priceReports: data['PriceReports'],
      );
    } else {
      return StoreModel.empty();
    }
  }

  factory StoreModel.fromQuerySnapshot(
    QueryDocumentSnapshot<Object?> document,
  ) {
    final data = document.data() as Map<String, dynamic>;
    return StoreModel(
      id: document.id,
      name: data['Name'] ?? '',
      location: data['Location'] ?? '',
      image: data['Image'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      lastUpdated: data['LastUpdated'].toDate(),
      priceReports: data['PriceReports'],
    );
  }
}
