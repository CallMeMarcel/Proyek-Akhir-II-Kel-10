import 'package:del_cafeshop/utils/theme/custom_themes/appbar_theme.dart';
import 'package:del_cafeshop/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:del_cafeshop/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:del_cafeshop/utils/theme/custom_themes/chip_theme.dart';
import 'package:del_cafeshop/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:del_cafeshop/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:del_cafeshop/utils/theme/custom_themes/text_field_theme.dart';
import 'package:del_cafeshop/utils/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class TAppTHeme {
  TAppTHeme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: TAppbarTheme.lightAppBarTheme,
    checkboxTheme: TCheckBoxTheme.lightCheckBoxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFieldTheme.lightInputDecorationTheme,

  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Rubik',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: TAppbarTheme.darkAppBarTheme,
    checkboxTheme: TCheckBoxTheme.darkCheckBoxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkELevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFieldTheme.darkInputDecorationTheme,
  );
   
}