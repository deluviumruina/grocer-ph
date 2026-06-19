import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/styles/shadows.dart';
import 'package:grocer_ph/common/widgets/containers/rounded_container.dart';
import 'package:grocer_ph/common/widgets/images/rounded_image.dart';
import 'package:grocer_ph/common/widgets/texts/product_price_text.dart';
import 'package:grocer_ph/common/widgets/texts/product_title_text.dart';
import 'package:grocer_ph/features/products/controllers/product_controller.dart';
import 'package:grocer_ph/features/products/screens/product_screen.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/features/products/screens/widgets/favorite_icon.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';

class ProductCardVertical extends StatelessWidget {
  const ProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => ProductScreen(product: product)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(Sizes.productImageRadius),
          color: dark ? AppColors.darkerGrey : Colors.white,
        ),
        child: Column(
          children: [
            RoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(Sizes.sm),
              backgroundColor: dark ? AppColors.dark : AppColors.light,
              child: Stack(
                children: [

                  /// -- Thumbnail Image
                  Center(
                    child: RoundedImage(
                      imageUrl: controller.formatImage(product),
                      applyImageRadius: true,
                      isNetworkImage: true,
                    ),
                  ),
                
                  /// -- Favorite Icon
                  Positioned(
                    top: 0,
                    right: 0,
                    child: FavoriteIcon(productId: product.id,),
                  ),
                ],
              ),
            ),

            /// -- Details
            const SizedBox(height: Sizes.spaceBtwItems / 2),
      
            Padding(
              padding: const EdgeInsets.only(left: Sizes.sm),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// -- Product Name
                    ProductTitleText(
                      title: product.name,
                      smallSize: true,
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems / 2),
                    
                    /// -- No. of Price Reports
                    Text(
                      controller.formatPriceReportNumber(product),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            /// -- Price Range
            Padding(
              padding: const EdgeInsets.all(Sizes.sm),
              child: SizedBox(
                width: double.infinity, 
                child: PriceText(price: controller.formatPriceRange(product))
              ),
            ),
          ],
        )
      ),
    );
  }
}