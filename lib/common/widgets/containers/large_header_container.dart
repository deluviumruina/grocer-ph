import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/containers/circular_container.dart';
import 'package:grocer_ph/common/widgets/shapes/curved_edge_widget.dart';
import 'package:grocer_ph/utils/constants/colors.dart';

class LargeHeaderContainer extends StatelessWidget {
  const LargeHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.only(bottom: 0),
          child: Stack(
            children: [
              Positioned(
                top: -150,
                right: -250,
                child: CircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Positioned(
                top: 100,
                right: -300,
                child: CircularContainer(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child,
            ],
          ),
        ),
    );
  }
}