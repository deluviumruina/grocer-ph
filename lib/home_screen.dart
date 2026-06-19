import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/common/widgets/buttons/floating_action_button.dart';
import 'package:grocer_ph/common/widgets/containers/large_header_container.dart';
import 'package:grocer_ph/common/widgets/layouts/grid_layout.dart';
import 'package:grocer_ph/common/widgets/containers/search_container.dart';
import 'package:grocer_ph/features/price_comparison/controllers/price_report_controller.dart';
import 'package:grocer_ph/features/products/controllers/product_controller.dart';
import 'package:grocer_ph/features/products/screens/all_products_screen.dart';
import 'package:grocer_ph/features/products/screens/widgets/product_card_vertical.dart';
import 'package:grocer_ph/common/widgets/texts/clickable_section_heading.dart';
import 'package:grocer_ph/features/products/screens/add_product_screen.dart';
import 'package:grocer_ph/features/price_comparison/screens/my_price_reports_screen.dart';
import 'package:grocer_ph/features/products/screens/widgets/product_categories.dart';
import 'package:grocer_ph/features/products/screens/widgets/product_search_delegate.dart';
import 'package:grocer_ph/features/profiles/controllers/user_controller.dart';
import 'package:grocer_ph/features/stores/controllers/store_category_controller.dart';
import 'package:grocer_ph/features/stores/controllers/store_controller.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/shimmer_vertical_card_grid.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    
    Get.put(StoreController());
    Get.put(StoreCategoryController());
    Get.put(UserController());
    Get.put(PriceReportController());
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LargeHeaderContainer(
              child: Column(
                children: [

                  /// -- App Bar
                  const HomeAppBar(),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  /// -- Search Bar
                  SearchContainer(
                    text: 'Search products',
                    onTap: () {
                      showSearch(
                        context: context, 
                        delegate: ProductSearchDelegate()
                      );
                    },
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),

                  /// -- Product Categories
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: Sizes.defaultSpace),
                    child: Column(
                      children: [
                        ClickableSectionHeading(
                          title: 'Categories',
                          textColor: Colors.white,
                          showActionButton: false,
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),

                        const ProductCategories(),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections,),
                ],
              ),
            ),

            /// -- All Products
            Padding(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: Column(
                children: [
                  ClickableSectionHeading(
                    title: 'Recent Price Reports',
                    onPressed: () => Get.to(() => const AllProductsScreen())
                  ),
                  const SizedBox(height: Sizes.spaceBtwItems),

                  /// -- All Products Grid
                  Obx(() {

                    if(controller.isLoading.value) return const VerticalCardGridShimmer();

                    if(controller.homeProducts.isEmpty) {
                      return Center(child: Text('No data found!', style: Theme.of(context).textTheme.bodyMedium,));
                    }

                    return GridLayout(
                      itemCount: controller.homeProducts.length, 
                      itemBuilder: (_, index) => ProductCardVertical(product: controller.homeProducts[index])
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: GFloatingActionButton(onPressed: () => Get.to(() => const AddProductScreen()),),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CROWDSOURCED GROCERY PRICE COMPARISON',
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.apply(color: AppColors.grey),
          ),
          Text(
            'GrocerPH User Testing',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.apply(color: Colors.white),
          ),
        ],
      ),
      
      /// -- My Price Reports Icon
      actions: [
        IconButton(
          onPressed: () => Get.to(() => const MyPriceReportsScreen()), 
          icon: Icon(Iconsax.notification, color: Colors.white)),
      ],
    );
  }
}
