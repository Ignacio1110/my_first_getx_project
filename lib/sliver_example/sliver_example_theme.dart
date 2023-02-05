import 'dart:ui';

import 'package:flutter/material.dart';

class SliverExampleTheme {
  static const Color kPrimary = Color(0xff2E5E4E);

  static const Color kSecondary = Color(0xffDBD3D8);
  static const Color kColor3 = Color(0xff93A7AA);
  static const Color kColor4 = Color(0xffA7B5B9);

  static const MaterialColor kPrimarySwatch =
      MaterialColor(0xff3f8a75, <int, Color>{
    50: Color(0xffe1f0ed),
    100: Color(0xffb7dbd2),
    200: Color(0xff8ac4b6),
    300: Color(0xff63ad9a),
    400: Color(0xff4c9b87),
    500: Color(0xff3f8a75),
    600: Color(0xff3a7d6a),
    700: Color(0xff346e5b),
    800: Color(0xff2e5e4e),
    900: Color(0xff244236)
  });

  static const MaterialColor kPrimarySecondary =
      MaterialColor(0xff87677d, <int, Color>{
    50: Color(0xfff1eeef),
    100: Color(0xffdbd3d8),
    200: Color(0xffc3b6bf),
    300: Color(0xffab97a5),
    400: Color(0xff997f91),
    500: Color(0xff87677d),
    600: Color(0xff7a5e72),
    700: Color(0xff695163),
    800: Color(0xff584556),
    900: Color(0xff473847)
  });

  static TextTheme textTheme = TextTheme(
      bodyText1: TextStyle(color: kPrimarySwatch.shade50),
      bodyText2: TextStyle(color: kPrimarySwatch.shade50));

  static ThemeData lightTheme = ThemeData(
    primaryColor: kPrimary,
    secondaryHeaderColor: kSecondary,
    primarySwatch: kPrimarySwatch,
    brightness: Brightness.light,
    textTheme: textTheme,
    buttonTheme: ButtonThemeData(
      buttonColor: kColor3,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    accentColor: Colors.pink,
    brightness: Brightness.dark,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
