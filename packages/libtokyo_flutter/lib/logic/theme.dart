import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:flutter/material.dart';
import 'color.dart';

ThemeData convertThemeData(libtokyo.ThemeData source, [Brightness brightness = Brightness.light]) {
  final textTheme = TextTheme().apply(
    package: source.package,
    displayColor: convertColor(source.foregroundColor),
    bodyColor: convertColor(source.gutterForegroundColor),
  );
  return ThemeData.from(
    colorScheme: ColorScheme(
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
    ),
    textTheme: textTheme,
  ).copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: convertColor(source.surfaceColor),
      foregroundColor: convertColor(source.foregroundColor),
      titleTextStyle: textTheme.titleLarge,
    ),
  );
}
