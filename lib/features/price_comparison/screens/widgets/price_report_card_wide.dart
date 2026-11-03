import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/containers/rounded_container.dart';
import 'package:grocer_ph/common/widgets/images/app_icons.dart';
import 'package:grocer_ph/common/widgets/texts/product_price_text.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';
import 'package:grocer_ph/features/price_comparison/screens/widgets/confirmation_button.dart';
import 'package:grocer_ph/features/profiles/controllers/user_controller.dart';
import 'package:grocer_ph/features/profiles/screens/profile_screen.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/formatters/formatters.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';
import 'package:iconsax/iconsax.dart';

class PriceReportCardWide extends StatelessWidget {
  const PriceReportCardWide({
    super.key, required this.priceReport, this.onTap,
  });

  final PriceReportModel priceReport;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: RoundedContainer(
        showBorder: true,
        borderColor: Colors.grey,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
      
                /// -- Price
                PriceText(
                  price: GFormatter.formatPrice(priceReport.price), 
                  isLarge: true
                ),
                const SizedBox(width: Sizes.spaceBtwItems),
      
                /// -- Date Reported
                Column(
                  children: [
                    SizedBox(height: Sizes.sm),
                    Text(
                      GFormatter.formatDate(priceReport.date), 
                      style: TextStyle(
                        fontSize: 12,
                        color: dark ? Colors.white : Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: Sizes.sm / 2),
        
            /// -- Store Name
            Row(
              children: [
                AppIcons(icon: Iconsax.shop),
                const SizedBox(width: Sizes.sm),
                Text(
                  priceReport.storeName, 
                  style: TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
      
            /// -- Store Location
            Row(
              children: [
                AppIcons(icon: Iconsax.map),
                const SizedBox(width: Sizes.sm),
                Text(
                  priceReport.storeLocation,
                  style: TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwItems / 2),
      
            const Divider(),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
      
                /// -- Username
                FutureBuilder(
                  future: UserController.instance.getProfile(priceReport.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ShimmerLoader(width: 150, height: 20);
                    }
                    final userProfile = snapshot.data!;
                    return InkWell(
                      onTap: () => Get.to(() => ProfileScreen(userProfile: userProfile)),
                      child: Row(
                        children: [
                          AppIcons(icon: Iconsax.user),
                          SizedBox(width: Sizes.sm),
                          Text(userProfile.username, style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    );
                  }
                ),
      
                /// -- Confirmations
                ConfirmationButtonAndCounter(priceReport: priceReport),
              ],
            )
          ],
        ),
      ),
    );
  }
}