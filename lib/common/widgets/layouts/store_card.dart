import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/containers/rounded_container.dart';
import 'package:grocer_ph/common/widgets/images/circular_image.dart';
import 'package:grocer_ph/common/widgets/texts/store_title_text.dart';
import 'package:grocer_ph/features/stores/controllers/store_controller.dart';
import 'package:grocer_ph/features/stores/models/store_model.dart';
import 'package:grocer_ph/features/stores/screens/store_screen.dart';
import 'package:grocer_ph/utils/constants/enums.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({
    super.key, 
    required this.store,
    this.onTap
  });

  final StoreModel store;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final controller = StoreController.instance;

    return InkWell(
      onTap: () => Get.to(() => StoreScreen(store: store)),
      child: RoundedContainer(
        showBorder: true,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(Sizes.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// -- Store Image
            CircularImage(
              isNetworkImage: true,
              image: controller.formatImage(store),
              backgroundColor: Colors.transparent,
            ),
            
            const SizedBox(width: Sizes.spaceBtwItems / 2),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StoreTitleText(
                    title: store.name,
                    storeTextSize: TextSizes.large,
                  ),
                  Text(
                    controller.formatPriceReportNumber(store),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
