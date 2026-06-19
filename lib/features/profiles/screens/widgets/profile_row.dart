import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class GProfileRow extends StatelessWidget {
  const GProfileRow({
    super.key,
    this.icon = Iconsax.copy,
    this.onPressed,
    required this.title,
    required this.value,
    this.showIcon = true,
  });

  final bool showIcon;
  final IconData icon;
  final VoidCallback? onPressed;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.spaceBtwItems / 1.5,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 7,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(child: Icon(showIcon ? icon : null, size: 18)),
          ],
        ),
      ),
    );
  }
}
