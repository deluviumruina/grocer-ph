import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/common/widgets/layouts/grid_layout.dart';
import 'package:grocer_ph/features/products/controllers/favorites_controller.dart';
import 'package:grocer_ph/features/products/screens/widgets/product_card_vertical.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/cloud_helper_functions.dart';
import 'package:grocer_ph/utils/loaders/shimmer_vertical_card_grid.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavoritesController.instance;

    return Scaffold(

      /// -- App Bar
      appBar: DefaultAppBar(
        title: Text(
          'Favorited Items', 
          style: Theme.of(context).textTheme.headlineMedium
        ),
      ),

      /// -- Favorite Products list
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Obx(
            () => FutureBuilder(
                  future: controller.favoriteProducts(),
                  builder: (context, snapshot) {
            
                    const loader = VerticalCardGridShimmer(itemCount: 6);
                    final widget = CloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                    if (widget != null) return widget;
            
                    final products = snapshot.data!;
                    
                    return GridLayout(
                      itemCount: products.length, 
                      itemBuilder: (_, index) => ProductCardVertical(product: products[index]),
                    );
                  }
                ),
          )
            ,
          )
        )
      )
    ;
  }
}