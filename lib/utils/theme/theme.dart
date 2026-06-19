import 'package:flutter/material.dart';
import 'package:grocer_ph/utils/theme/custom_themes/appbar_theme.dart';
import 'package:grocer_ph/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:grocer_ph/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:grocer_ph/utils/theme/custom_themes/chip_theme.dart';
import 'package:grocer_ph/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:grocer_ph/utils/theme/custom_themes/outlined_button.dart';
import 'package:grocer_ph/utils/theme/custom_themes/text_field_theme.dart';
import 'package:grocer_ph/utils/theme/custom_themes/text_theme.dart';

class GAppTheme {
  GAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GTextTheme.lightTextTheme,
    appBarTheme: DefaultAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: GBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: GCheckboxTheme.lightCheckboxTheme,
    chipTheme: GChipTheme.lightChipTheme,
    elevatedButtonTheme: GElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: GTextFieldTheme.lightInputDecorationTheme,
    outlinedButtonTheme: GOutlinedButtonTheme.lightOutlinedButtonTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: GTextTheme.darkTextTheme,
    appBarTheme: DefaultAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: GBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: GCheckboxTheme.darkCheckboxTheme,
    chipTheme: GChipTheme.darkChipTheme,
    elevatedButtonTheme: GElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: GTextFieldTheme.darkInputDecorationTheme,
    outlinedButtonTheme: GOutlinedButtonTheme.darkOutlinedButtonTheme,
  );
}