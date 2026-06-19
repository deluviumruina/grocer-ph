import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/images/circular_image.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';

class VerticalImageAndText extends StatelessWidget {
  const VerticalImageAndText({
    super.key,
    this.onTap,
    required this.image,
    this.isNetworkImage = true,
    required this.title,
    this.textColor = Colors.white,
    this.backgroundColor,
  });

  final String image, title;
  final bool isNetworkImage;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: Sizes.spaceBtwItems),
        child: Column(
          children: [
            
            /// -- Image
            CircularImage(
              image: image,
              imageWidth: 40,
              isNetworkImage: isNetworkImage,
              padding: Sizes.sm / 2,
              overlayColor: dark ? AppColors.light : AppColors.dark,
              backgroundColor: backgroundColor,
            ),
            const SizedBox(height: Sizes.spaceBtwItems / 2),

            /// -- Text
            SizedBox(
              width: 55,
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.apply(color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}