import 'package:flutter/material.dart';

class TokyoThemeFactory {
  static TextTheme getTextTheme([Color color = Colors.black]) => TextTheme(
    headline1: TextStyle(
      fontSize: 26,
      color: color,
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      fontSize: 21,
      color: color,
      fontWeight: FontWeight.bold,
    ),
    headline3: TextStyle(
      fontSize: 20,
      color: color,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 17,
      color: color,
      fontWeight: FontWeight.bold,
    ),
    headline5: TextStyle(
      fontSize: 15,
      color: color,
      fontWeight: FontWeight.bold,
    ),
    headline6: TextStyle(
      fontSize: 13,
      color: color,
      fontWeight: FontWeight.w600,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      color: color,
    ),
    caption: TextStyle(
      fontSize: 13,
      color: color,
      fontWeight: FontWeight.w400,
    ),
  );
}
