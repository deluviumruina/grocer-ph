import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/common/widgets/buttons/bottom_navigation_bar_button.dart';
import 'package:grocer_ph/common/widgets/containers/bottom_navigation_bar.dart';
import 'package:grocer_ph/common/widgets/shapes/curved_edge_widget.dart';
import 'package:grocer_ph/common/widgets/texts/clickable_section_heading.dart';
import 'package:grocer_ph/common/widgets/texts/product_price_text.dart';
import 'package:grocer_ph/common/widgets/texts/product_title_text.dart';
import 'package:grocer_ph/features/price_comparison/controllers/price_report_controller.dart';
import 'package:grocer_ph/features/price_comparison/screens/add_price_report_screen.dart';
import 'package:grocer_ph/features/price_comparison/screens/price_reports_detail_screen.dart';
import 'package:grocer_ph/features/price_comparison/screens/all_price_reports_screen.dart';
import 'package:grocer_ph/features/price_comparison/screens/widgets/price_report_card_wide.dart';
import 'package:grocer_ph/features/products/screens/update_product_screen.dart';
import 'package:grocer_ph/features/products/screens/widgets/favorite_icon.dart';
import 'package:grocer_ph/features/products/controllers/product_controller.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/cloud_helper_functions.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';
import 'package:grocer_ph/utils/loaders/shimmer_sizes.dart';
import 'package:readmore/readmore.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final priceReportController = PriceReportController.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [

                /// -- Product Image
                ProductDetailsImage(product: product),

                /// -- App Bar (Back Button and Add to Favorites Button)
                DefaultAppBar(
                  showBackArrow: true,
                  actions: [FavoriteIcon(productId: product.id,)],
                )
              ],
            ),

            /// -- Product Details
            Padding(
              padding: EdgeInsets.only(right: Sizes.defaultSpace, left: Sizes.defaultSpace, bottom: Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// -- Price Range
                  PriceText(
                    price: controller.formatPriceRange(product),
                    isLarge: true,
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems / 1.5),
          
                  /// -- Product Name
                  ProductTitleText(title: product.name),
                  const SizedBox(height: Sizes.spaceBtwItems),

                  /// -- Description
                  const ClickableSectionHeading(title: 'Description', showActionButton: false,),
                  const SizedBox(height: Sizes.spaceBtwItems / 2),
                  ReadMoreText(
                    controller.formatDescription(product),
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),

                  const Divider(),
                  const SizedBox(height: Sizes.spaceBtwItems / 2),

                  /// -- Price Reports
                  ClickableSectionHeading(
                    title: 'Price Reports (${product.priceReports.toString()})', 
                    onPressed: () => Get.to(() => AllPriceReportsScreen(product: product)),
                  ),

                  FutureBuilder(
                    future: priceReportController.getLimitedProductPriceReports(product.id), 
                    builder: (context, snapshot) {
                      const loader = PriceReportCardWideShimmer();
                      final widget = CloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                      if (widget != null) return widget;

                      final limitedProductPriceReports = snapshot.data!;

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: limitedProductPriceReports.length,
                        itemBuilder: (_, index) {
                          return PriceReportCardWide(
                            priceReport: limitedProductPriceReports[index],
                            onTap: () => Get.to(() => PriceReportsDetailScreen(selectedPriceReport: limitedProductPriceReports[index])),
                          );
                        }, 
                        separatorBuilder: (_, index) => const SizedBox(height: Sizes.spaceBtwItems) 
                      );
                    }
                  )
                ],
              )
            )
          ],
        ),
      ),

      /// -- Price Report Button
      bottomNavigationBar: ProductBottomNavigationBar(product: product),
    );
  }
}

class ProductDetailsImage extends StatelessWidget {
  const ProductDetailsImage({
    super.key, required this.product
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return CurvedEdgesWidget(
      child: Container(
        color: dark ? AppColors.darkerGrey : AppColors.light,
        child: SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(
              Sizes.productImageRadius * 2.5,
            ),
            child: Center(
              child: CachedNetworkImage(
                imageUrl: controller.formatImage(product),
                progressIndicatorBuilder: (_, _, downloadProgress) => 
                  CircularProgressIndicator(value: downloadProgress.progress, color: AppColors.primary,) ,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductBottomNavigationBar extends StatelessWidget {
  const ProductBottomNavigationBar({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return AppBottomNavigationBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BottomNavigationBarButton(
            buttonText: 'Update Product', 
            onPressed: () => Get.to(() => UpdateProductScreen(product: product))
          ),
          const SizedBox(width: Sizes.spaceBtwItems),
          BottomNavigationBarButton(
            buttonText: 'Add Price Report', 
            onPressed: () => Get.to(() => AddPriceReportScreen(product: product))
          )
        ],
      ),
    );
  }
}
