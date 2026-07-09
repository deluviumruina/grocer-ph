import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/containers/app_bar.dart';
import 'package:grocer_ph/common/widgets/buttons/bottom_navigation_bar_button.dart';
import 'package:grocer_ph/common/widgets/containers/bottom_navigation_bar.dart';
import 'package:grocer_ph/features/products/screens/widgets/sortable_products.dart';
import 'package:grocer_ph/features/stores/models/store_model.dart';
import 'package:grocer_ph/features/stores/screens/update_store_screen.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Text(store.name), showBackArrow: true),
      body: SortableProducts(
        queryFirst: FirebaseFirestore.instance
            .collection('Products')
            .where('Stores', arrayContains: store.id)
            .orderBy('LastUpdated', descending: true),
        queryMore: FirebaseFirestore.instance
            .collection('Products')
            .where('Stores', arrayContains: store.id)
            .orderBy('LastUpdated', descending: true),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomNavigationBarButton(
              buttonText: 'Update Store',
              onPressed: () => Get.to(() => UpdateStoreScreen(store: store)),
            ),
          ],
        ),
      ),
    );
  }
}
