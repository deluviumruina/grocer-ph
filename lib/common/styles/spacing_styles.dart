import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class SpacingStyle{
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: Sizes.appBarHeight,
    left: Sizes.defaultSpace,
    bottom: Sizes.defaultSpace,
    right: Sizes.defaultSpace, 
  );
}