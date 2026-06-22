import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';

class StoreCardShimmer extends StatelessWidget {
  const StoreCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLoader(width: 360, height: 70, radius: 10);
  }
}

class PriceReportCardWideShimmer extends StatelessWidget {
  const PriceReportCardWideShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLoader(width: 360, height: 185, radius: 10);
  }
}

class PriceReportCardNarrowShimmer extends StatelessWidget {
  const PriceReportCardNarrowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLoader(width: 360, height: 80, radius: 10);
  }
}

class OutlinedButtonShimmer extends StatelessWidget {
  const OutlinedButtonShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLoader(width: 150, height: 50, radius: 10);
  }
}

class FormImageShimmer extends StatelessWidget {
  const FormImageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerLoader(width: 300, height: 150);
  }
}