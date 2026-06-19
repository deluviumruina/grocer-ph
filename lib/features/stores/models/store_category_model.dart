import 'package:cloud_firestore/cloud_firestore.dart';

class StoreCategoryModel {
  String id;
  String name;

  StoreCategoryModel({
    required this.id,
    required this.name,
  });

  /// -- Empty
  static StoreCategoryModel empty() => StoreCategoryModel(id: '', name: '');

  /// -- Model -> Firebase(JSON)
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
    };
  }

  /// -- Firebase(JSON) -> Model
  factory StoreCategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return StoreCategoryModel(
        id: document.id, 
        name: data['Name'] ?? ''
      );
    } else {
      return StoreCategoryModel.empty();
    }
  }

}