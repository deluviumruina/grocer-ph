import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/features/products/screens/widgets/sortable_products.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Text('All Products'), showBackArrow: true),
      body: SortableProducts(
        queryFirst: FirebaseFirestore.instance
            .collection('Products')
            .orderBy('LastUpdated', descending: true),
        queryMore: FirebaseFirestore.instance
            .collection('Products')
            .orderBy('LastUpdated', descending: true),
      ),
    );
  }
}
