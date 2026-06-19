import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class GNarrowVerticalGridLayout extends StatelessWidget {
  const GNarrowVerticalGridLayout({
    super.key, required this.itemCount, required this.itemBuilder,
  });

  final int itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (_, _) =>
          const SizedBox(height: Sizes.spaceBtwSections),
      itemBuilder: itemBuilder,
    );
  }
}