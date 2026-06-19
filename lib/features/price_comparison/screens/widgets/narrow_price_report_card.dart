import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/images/rounded_image.dart';
import 'package:grocer_ph/common/widgets/texts/product_price_text.dart';
import 'package:grocer_ph/common/widgets/texts/product_title_text.dart';
import 'package:grocer_ph/common/widgets/texts/store_title_text.dart';
import 'package:grocer_ph/features/price_comparison/controllers/price_report_controller.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/formatters/formatters.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class NarrowPriceReportCard extends StatelessWidget {
  const NarrowPriceReportCard({super.key, required this.priceReport, this.onTap});

  final PriceReportModel priceReport;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final controller = PriceReportController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Column(
                  children: [
      
                    /// -- Product Image
                    RoundedImage(
                      isNetworkImage: true,
                      imageUrl: controller.formatImage(priceReport),
                      width: 60,
                      height: 60,
                      padding: EdgeInsets.all(Sizes.sm),
                      backgroundColor: dark ? AppColors.darkerGrey : AppColors.light,
                    ),
      
                    const SizedBox(height: Sizes.spaceBtwItems / 5),
      
                    /// -- Date Reported
                    Center(
                      child: Text(
                        GFormatter.formatShortDate(priceReport.date),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: Sizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
      
                      /// -- Store Name & Location
                      Flexible(child: StoreTitleText(title: priceReport.storeName)),
      
                      /// -- Price Report
                      PriceText(price: GFormatter.formatPrice(priceReport.price)),
      
                      /// -- Product Name
                      Flexible(
                        child: ProductTitleText(
                          title: priceReport.productName,
                          smallSize: true,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 55),
              Row(
                children: [
                  Icon(Iconsax.like_1),
                  const SizedBox(width: Sizes.spaceBtwItems / 2),
                  Text(priceReport.confirmations.toString(), style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
