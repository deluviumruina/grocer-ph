import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';

class AppIcons extends StatelessWidget {
  const AppIcons({
    super.key, 
    required this.icon, 
    this.size
  });

  final IconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Icon(
      icon,
      size: size,
      color: dark ? Colors.white : Colors.black.withValues(alpha: 0.55),
    );
  }
}