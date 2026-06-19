import 'package:flutter/material.dart';
import 'package:grocer_ph/data/repositories/authentication_repository.dart';
import 'package:grocer_ph/data/repositories/price_report_repository.dart';
import 'package:grocer_ph/data/repositories/user_repository.dart';
import 'package:grocer_ph/features/price_comparison/models/price_report_model.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class ConfirmationButtonAndCounter extends StatefulWidget {
  const ConfirmationButtonAndCounter({super.key, required this.priceReport});

  final PriceReportModel priceReport;

  @override
  State<ConfirmationButtonAndCounter> createState() => _ConfirmationButtonAndCounterState();
}

class _ConfirmationButtonAndCounterState extends State<ConfirmationButtonAndCounter> {
  final user = AuthenticationRepository.instance.authUser!;
  int counter = 0;
  bool isLiked = false;

  @override
  void initState(){
    super.initState();
    isLiked = widget.priceReport.confirmationsList!.contains(user.uid);
    counter = widget.priceReport.confirmations!;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;

      if (isLiked) {
        counter++;
      } else {
        counter --;
      }
    });

    PriceReportRepository.instance.toggleLike(widget.priceReport, user.uid, isLiked);
    UserRepository.instance.toggleLike(widget.priceReport, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        /// -- Confirmation Button
        IconButton(
          onPressed: toggleLike, 
          icon: Icon(
            isLiked ? Iconsax.like_15 : Iconsax.like_1,
            color: isLiked ? AppColors.primary : null,
          )
        ),

        Text(
          counter.toString(), 
          style: Theme.of(context).textTheme.titleSmall
        ),
        const SizedBox(width: Sizes.sm)
      ],
    );
  }
}