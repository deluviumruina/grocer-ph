import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/containers/rounded_container.dart';
import 'package:grocer_ph/common/widgets/texts/product_price_text.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';
import 'package:grocer_ph/features/price_comparison/screens/widgets/confirmation_button.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/formatters/formatters.dart';
import 'package:iconsax/iconsax.dart';

class PriceReportCardDetail extends StatelessWidget {
  const PriceReportCardDetail({super.key, required this.priceReport});

  final PriceReportModel priceReport;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      showBorder: true,
      borderColor: Colors.grey,
      padding: EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [

                  /// -- Price
                  PriceText(
                    price: GFormatter.formatPrice(priceReport.price),
                    isLarge: true,
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems),

                  /// -- Date Reported
                  Column(
                    children: [
                      SizedBox(height: Sizes.sm),
                      Text(
                        GFormatter.formatShortDate(priceReport.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Sizes.sm / 2),

              /// -- Date and UserName
              Row(
                children: [
                  Icon(
                    Iconsax.user,
                    size: 14,
                    color: Colors.black.withValues(alpha: 0.55),
                  ),
                  SizedBox(width: Sizes.sm / 2),
                  Text(
                    priceReport.userName,
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),

          /// -- Confirmations
          ConfirmationButtonAndCounter(priceReport: priceReport),
        ],
      ),
    );
  }
}
