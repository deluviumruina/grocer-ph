import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/containers/rounded_container.dart';
import 'package:grocer_ph/common/widgets/images/rounded_image.dart';
import 'package:grocer_ph/common/widgets/texts/product_price_text.dart';
import 'package:grocer_ph/common/widgets/texts/product_title_text.dart';
import 'package:grocer_ph/features/products/controllers/product_controller.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';

class ProductCardHorizontal extends StatelessWidget {
  const ProductCardHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.productImageRadius),
        color: dark ? AppColors.darkerGrey : AppColors.softGrey
      ),
      child: Row(children: [

        /// -- Thumbnail
        RoundedContainer(
          height: 120,
          padding: const EdgeInsets.all(Sizes.sm),
          backgroundColor: dark ? AppColors.dark : AppColors.light,
          child: SizedBox(
            height: 120,
            width: 120,
            child: RoundedImage(
              imageUrl: controller.formatImage(product),
              applyImageRadius: true,
              isNetworkImage: true
            ),
          ),
        ),

        /// -- Product Details
        SizedBox(
          width: 172,
          child: Padding(
            padding: EdgeInsets.only(top: Sizes.sm, left: Sizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
                /// -- Product Name
                ProductTitleText(title: product.name, smallSize: true),
                SizedBox(height: Sizes.spaceBtwItems / 2),
            
                /// -- No. of Price Reports
                Text(
                  controller.formatPriceReportNumber(product), 
                  overflow: TextOverflow.ellipsis, 
                  maxLines: 1, style: Theme.of(context).textTheme.labelMedium
                ),
                SizedBox(height: Sizes.spaceBtwItems / 2),

                /// -- Price Range
                PriceText(price: controller.formatPriceRange(product))
              ],
            ),
          ),
        ),
      ])
    );
  }
}