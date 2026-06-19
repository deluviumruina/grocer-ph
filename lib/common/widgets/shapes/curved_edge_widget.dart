import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/shapes/curved_edge_clipper.dart';

class CurvedEdgesWidget extends StatelessWidget {
  const CurvedEdgesWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedEdgesClipper(), 
      child: child);
  }
}