import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:flutter/material.dart';
import 'color.dart';

TextTheme applyTextTheme(TextTheme base, libtokyo.ThemeData source, [Brightness brightness = Brightness.light]) =>
  base.apply(
    package: source.package,
    displayColor: convertColor(source.foregroundColor),
    bodyColor: convertColor(source.foregroundColor),
  );

ThemeData convertThemeData(libtokyo.ThemeData source, [Brightness brightness = Brightness.light]) {
  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: convertColor(source.foregroundColor),
    onPrimary: convertColor(source.darkForegroundColor),
    secondary: convertColor(source.blueColors[0]),
    onSecondary: convertColorMaterial(source.blueColors.sublist(1)),
    error: convertColor(source.redColors[0]),
    onError: convertColor(source.redColors[1]),
    background: convertColor(source.backgroundColor),
    onBackground: convertColor(source.darkBackgroundColor),
    surface: convertColor(source.surfaceColor),
    onSurface: convertColor(source.darkSurfaceColor),
  );

  final typography = Typography.material2021(
    colorScheme: colorScheme,
    black: applyTextTheme(Typography.blackMountainView, source, brightness),
    white: applyTextTheme(Typography.whiteMountainView, source, brightness),
    englishLike: applyTextTheme(Typography.englishLike2021, source, brightness),
    dense: applyTextTheme(Typography.dense2021, source, brightness),
    tall: applyTextTheme(Typography.tall2021, source, brightness),
  );

  return ThemeData.from(
    colorScheme: colorScheme,
    textTheme: typography.englishLike,
  ).copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: convertColor(source.surfaceColor),
      foregroundColor: convertColor(source.foregroundColor),
      titleTextStyle: typography.englishLike.titleLarge,
      toolbarTextStyle: typography.englishLike.titleLarge,
    ),
    primaryTextTheme: typography.englishLike,
    typography: typography,
  );
}
