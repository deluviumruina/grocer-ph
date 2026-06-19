import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCategoryModel {
  String id;
  String name;
  String image;

  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.image
  });

  /// -- Empty
  static ProductCategoryModel empty() => ProductCategoryModel(id: '', name: '', image: '');

  /// -- Model -> Firebase(JSON)
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Image': image
    };
  }

  /// -- Firebase(JSON) -> Model
  factory ProductCategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return ProductCategoryModel(
        id: document.id, 
        name: data['Name'] ?? '', 
        image: data['Image'] ?? ''
      );
    } else {
      return ProductCategoryModel.empty();
    }
  }

}