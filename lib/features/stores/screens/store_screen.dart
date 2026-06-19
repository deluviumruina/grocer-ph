import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/common/widgets/buttons/bottom_navigation_bar_button.dart';
import 'package:grocer_ph/common/widgets/containers/bottom_navigation_bar.dart';
import 'package:grocer_ph/features/products/screens/widgets/sortable_products.dart';
import 'package:grocer_ph/features/stores/controllers/store_controller.dart';
import 'package:grocer_ph/features/stores/models/store_model.dart';
import 'package:grocer_ph/features/stores/screens/update_store_screen.dart';
import 'package:grocer_ph/utils/helpers/cloud_helper_functions.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final controller = StoreController.instance;

    return Scaffold(
      appBar: DefaultAppBar(title: Text(store.name), showBackArrow: true),
      body: FutureBuilder(
        future: controller.getStoreProductIds(store.id),
        builder: (_, snapshot) {
          final loader = const Center(child: CircularProgressIndicator());
          final widget = CloudHelperFunctions.checkMultiRecordState(loader: loader, snapshot: snapshot);

          if (widget != null) {
            return widget;
          } else {
            final ids = snapshot.data!;

            return SortableProducts(
              queryFirst: FirebaseFirestore.instance
                  .collection('Products')
                  .where(FieldPath.documentId, whereIn: ids),
              queryMore: FirebaseFirestore.instance
                  .collection('Products')
                  .where(FieldPath.documentId, whereIn: ids),
            );
          }
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomNavigationBarButton(
              buttonText: 'Update Store', onPressed: () => Get.to(() => UpdateStoreScreen(store: store))
            ),
          ],
        )
      ),
    );
  }
}
