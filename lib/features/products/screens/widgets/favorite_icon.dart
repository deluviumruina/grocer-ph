import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/images/circular_icon.dart';
import 'package:grocer_ph/features/products/controllers/favorites_controller.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());
    return Obx(
      () => CircularIcon(
        icon: controller.isFavorite(productId) ? Iconsax.heart5 : Iconsax.heart, 
        color: controller.isFavorite(productId) ? AppColors.error : null,
        onPressed: () => controller.toggleFavoriteProduct(productId),
      )
    );
  }
}