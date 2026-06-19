import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';
import 'package:grocer_ph/utils/loaders/shimmer_vertical_card_grid.dart';

class VerticalCardGridWithSortShimmer extends StatelessWidget {
  const VerticalCardGridWithSortShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerLoader(
          width: double.infinity * 0.8, 
          height: 50
        ),
        const SizedBox(height: Sizes.spaceBtwSections),
        const VerticalCardGridShimmer(),
      ],
    );
  }
}