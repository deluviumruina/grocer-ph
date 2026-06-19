import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    required this.image,
    this.isNetworkImage = false,
    this.width = 56,
    this.height = 56,
    this.padding = Sizes.sm,
    this.imageWidth,
    this.imageHeight,
    this.overlayColor,
    this.backgroundColor,
    this.fit = BoxFit.cover,
  });

  final String image;
  final bool isNetworkImage;
  final double width, height, padding;
  final double? imageWidth, imageHeight;
  final BoxFit? fit;
  final Color? overlayColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (dark ? AppColors.black : Colors.white),
        borderRadius: BorderRadius.circular(100)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage
            ? CachedNetworkImage (
              width: imageWidth,
              height: imageHeight,
              fit: fit,
              color: overlayColor,
              imageUrl: image,
              progressIndicatorBuilder: (context, url, downloadProgress) => const ShimmerLoader(width: 55, height: 55, radius: 55),
              errorWidget: (context, url, error) => const Icon(Icons.error)
            )
            : Image (
              fit: fit,
              image: AssetImage(image),
              color: overlayColor,
            )
        ),
      ),
    );
  }
}
