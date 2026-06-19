import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    this.currencySign = '₱',
    required this.price,
    this.maxLines = 1,
    this.isLarge = false,
  });

  final String currencySign, price;
  final int maxLines;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
        ? Theme.of(context).textTheme.headlineMedium
        : Theme.of(context).textTheme.titleLarge
    );
  }
}
