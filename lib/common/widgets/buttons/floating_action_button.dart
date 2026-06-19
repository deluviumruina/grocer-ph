import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class GFloatingActionButton extends StatelessWidget {
  const GFloatingActionButton({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: onPressed,
      child: const Icon(Iconsax.add, color: Colors.white),
    );
  }
}