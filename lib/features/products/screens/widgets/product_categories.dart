import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/texts/vertical_image_text.dart';
import 'package:grocer_ph/features/products/controllers/product_category_controller.dart';
import 'package:grocer_ph/features/products/screens/product_category_screen.dart';
import 'package:grocer_ph/utils/loaders/shimmer_category.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductCategoryController());

    return Obx(() {

      if(controller.isLoading.value) return const CategoryShimmer();

      if(controller.allProductCategories.isEmpty) {
        return Center(child: Text('No data found!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
      }

      return SizedBox(
        height: 80,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.allProductCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final productCategory = controller.allProductCategories[index];
            return VerticalImageAndText(
              image: productCategory.image,
              title: productCategory.name,
              onTap: () => Get.to(() => ProductCategoryScreen(productCategory: productCategory)),
            );
          },
        ),
      );
    });
  }
}
