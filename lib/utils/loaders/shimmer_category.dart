import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({
    super.key, 
    this.itemCount = 9
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, _) => const SizedBox(width: Sizes.spaceBtwItems),
        itemBuilder: (_, _) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// -- Shimmer over image
              ShimmerLoader(width: 55, height: 55, radius: 55),
              SizedBox(height: Sizes.spaceBtwItems / 2),

              /// -- Shimmer over text
              ShimmerLoader(width: 55, height: 8),
            ],
          );
        },
      ),
    );
  }
}
