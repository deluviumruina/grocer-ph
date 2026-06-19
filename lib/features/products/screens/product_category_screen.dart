import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/features/products/models/product_category_model.dart';
import 'package:grocer_ph/features/products/screens/widgets/sortable_products.dart';

class ProductCategoryScreen extends StatelessWidget {
  const ProductCategoryScreen({super.key, required this.productCategory});

  final ProductCategoryModel productCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: Text(productCategory.name),
        showBackArrow: true,
      ),
      body: SortableProducts(
        queryFirst: FirebaseFirestore.instance
            .collection('Products')
            .where('CategoryId', isEqualTo: productCategory.id)
            .orderBy('LastUpdated', descending: true),
        queryMore: FirebaseFirestore.instance
            .collection('Products')
            .where('CategoryId', isEqualTo: productCategory.id)
            .orderBy('LastUpdated', descending: true),
      ),
    );
  }
}
