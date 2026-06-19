import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/layouts/grid_layout.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';

class VerticalCardGridShimmer extends StatelessWidget {
  const VerticalCardGridShimmer({
    super.key,
    this.itemCount = 6
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridLayout(
      itemCount: itemCount, 
      itemBuilder: (_, _) => const SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            /// -- Shimmer over image
            ShimmerLoader(width: 180, height: 180),
            SizedBox(height: Sizes.spaceBtwItems),

            /// -- Shimmer over text
            ShimmerLoader(width: 160, height: 15),
            SizedBox(height: Sizes.spaceBtwItems / 2),
            ShimmerLoader(width: 110, height: 15)
          ],
        ),
      )
    );
  }
}