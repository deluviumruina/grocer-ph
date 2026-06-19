import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final int priceReports;
  final int reputation;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.priceReports,
    required this.reputation
  });

  /// -- Creates Empty User Model
  static UserModel empty() => UserModel(
      id: "",
      username: "",
      email: "",
      priceReports: 0,
      reputation: 0
    );

  /// -- Model -> Firebase(JSON)
  Map<String, dynamic> toJson() {
    return {
      'Username': username,
      'Email': email,
      'PriceReports': priceReports,
      'Reputation': reputation
    };
  }

  /// -- Firebase(JSON) -> Model
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      username: data['Username'] ?? "",
      email: data['Email'] ?? "",
      priceReports: data['PriceReports'] ?? 0,
      reputation: data['Reputation'] ?? 0
    );
  }
}