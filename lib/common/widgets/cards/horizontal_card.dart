import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/containers/rounded_container.dart';
import 'package:grocer_ph/common/widgets/layouts/store_card.dart';
import 'package:grocer_ph/features/stores/models/store_model.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class GHorizontalCard extends StatelessWidget {
  const GHorizontalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      showBorder: true,
      borderColor: AppColors.darkGrey,
      padding: const EdgeInsets.all(Sizes.md),
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
      child: Column(children: [StoreCard(store: StoreModel.empty())]),
    );
  }
}