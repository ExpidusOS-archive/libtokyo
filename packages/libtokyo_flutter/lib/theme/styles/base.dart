import 'package:material_theme_builder/material_theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'dart:ui' show Brightness;

import 'package:libtokyo_flutter/theme/factory.dart';

MaterialColor createMaterialColor(Color color) {
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

abstract class TokyoBaseStyle {
  const TokyoBaseStyle();

  Color getPrimaryColor();
  Color getSecondaryColor();
  Color getTertiaryColor();
  Color getNeutralColor();
  Color getErrorColor() => getTertiaryColor();
  Color getDisabledColor() => getSecondaryColor();
  Color getHighlightColor() => getTertiaryColor();
  Color getHintColor() => getPrimaryColor();
  Color getHoverColor() => getSecondaryColor();
  Color getTextColor() => getPrimaryColor();

  Brightness getBrightness() => Brightness.light;

  TextTheme getTextTheme() => TokyoThemeFactory.getTextTheme(getTextColor());

  ColorScheme getColorScheme() => MaterialThemeBuilder(
    brightness: getBrightness(),
    primary: getPrimaryColor(),
    secondary: getSecondaryColor(),
    tertiary: getTertiaryColor(),
    neutral: getNeutralColor(),
    error: getErrorColor(),
  ).toScheme();

  ButtonStyle getButtonStyle();

  SystemUiOverlayStyle getSystemOverlayStyle() => getBrightness() == Brightness.light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

  AppBarTheme getAppBarTheme() => AppBarTheme(
    centerTitle: true,
    elevation: 3.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    titleTextStyle: getTextTheme().headline2,
    systemOverlayStyle: getSystemOverlayStyle(),
  );

  SwitchThemeData getSwitchTheme() => SwitchThemeData();

  MaterialBannerThemeData getBannerTheme() => MaterialBannerThemeData(
    elevation: 3.0,
  );

  ThemeData create({String? fontFamily}) {
    final colorScheme = getColorScheme();
    final appBarTheme = getAppBarTheme();
    return ThemeData(
      applyElevationOverlayColor: false,
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: getBrightness(),
      canvasColor: getPrimaryColor(),
      cardColor: getSecondaryColor(),
      colorScheme: colorScheme,
      disabledColor: getDisabledColor(),
      highlightColor: getHighlightColor(),
      hintColor: getHintColor(),
      hoverColor: getHoverColor(),
      textTheme: getTextTheme(),
      errorColor: getErrorColor(),
      indicatorColor: colorScheme.secondary,
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: appBarTheme.backgroundColor,
        elevation: appBarTheme.elevation,
      ),
      textButtonTheme: TextButtonThemeData(
        style: getButtonStyle(),
      ),
      appBarTheme: appBarTheme,
      switchTheme: getSwitchTheme(),
      bannerTheme: getBannerTheme(),
    );
  }
}
