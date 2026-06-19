import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';

class VerticalCardShimmer extends StatelessWidget {
  const VerticalCardShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLoader(width: 180, height: 180),
        SizedBox(height: Sizes.spaceBtwItems),

        ShimmerLoader(width: 160, height: 15),
        SizedBox(height: Sizes.spaceBtwItems / 2),
        ShimmerLoader(width: 110, height: 15),
      ],
    );
  }
}
