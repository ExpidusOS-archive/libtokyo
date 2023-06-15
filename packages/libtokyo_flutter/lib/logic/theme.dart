import 'dart:convert';

import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:flutter/material.dart';
import '../widgets.dart';
import 'color.dart';

Brightness _inverseBrightness(Brightness brightness) => brightness == Brightness.light ? Brightness.dark : Brightness.light;

TextTheme applyTextTheme(TextTheme base, libtokyo.ThemeData source, [Brightness brightness = Brightness.light]) {
  final color = convertColor(brightness == Brightness.light ? source.foregroundColor : source.gutterForegroundColor);
  return TextTheme(
    displayLarge: base.displayLarge?.copyWith(inherit: true),
    displayMedium: base.displayMedium?.copyWith(inherit: true),
    displaySmall: base.displaySmall?.copyWith(inherit: true),
    headlineLarge: base.headlineLarge?.copyWith(inherit: true),
    headlineMedium: base.headlineMedium?.copyWith(inherit: true),
    headlineSmall: base.headlineSmall?.copyWith(inherit: true),
    titleLarge: base.titleLarge?.copyWith(inherit: true),
    titleMedium: base.titleMedium?.copyWith(inherit: true),
    titleSmall: base.titleSmall?.copyWith(inherit: true),
    bodyLarge: base.bodyLarge?.copyWith(inherit: true),
    bodyMedium: base.bodyMedium?.copyWith(inherit: true),
    bodySmall: base.bodySmall?.copyWith(inherit: true),
    labelLarge: base.labelLarge?.copyWith(inherit: true),
    labelMedium: base.labelMedium?.copyWith(inherit: true),
    labelSmall: base.labelSmall?.copyWith(inherit: true),
  ).apply(
    package: source.package,
    displayColor: color,
    bodyColor: color,
  );
}

ThemeData convertThemeData(libtokyo.ThemeData source, [Brightness brightness = Brightness.light]) {
  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: convertColor(brightness == Brightness.light ? source.foregroundColor : source.darkForegroundColor),
    onPrimary: convertColor(brightness == Brightness.light ? source.foregroundColor : source.darkForegroundColor),
    secondary: convertColor(source.blueColors[0]),
    onSecondary: convertColorMaterial(source.blueColors.sublist(1)),
    error: convertColor(source.redColors[0]),
    onError: convertColor(source.redColors[1]),
    background: convertColor(brightness == Brightness.light ? source.backgroundColor : source.darkBackgroundColor),
    onBackground: convertColor(brightness == Brightness.light ? source.backgroundColor : source.darkBackgroundColor),
    surface: convertColor(brightness == Brightness.light ? source.surfaceColor : source.darkSurfaceColor),
    onSurface: convertColor(brightness == Brightness.light ? source.surfaceColor : source.darkSurfaceColor),
  );

  final typography = Typography.material2021(
    colorScheme: colorScheme,
    black: applyTextTheme(Typography.blackMountainView, source, Brightness.dark),
    white: applyTextTheme(Typography.whiteMountainView, source, Brightness.light),
    englishLike: applyTextTheme(Typography.englishLike2021, source, _inverseBrightness(brightness)),
    dense: applyTextTheme(Typography.dense2021, source, _inverseBrightness(brightness)),
    tall: applyTextTheme(Typography.tall2021, source, _inverseBrightness(brightness)),
  );

  final iconTheme = IconThemeData(
    color: colorScheme.primary,
  );

  return ThemeData.from(
    colorScheme: colorScheme,
    textTheme: typography.englishLike,
  ).copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.primary,
      iconTheme: iconTheme,
      actionsIconTheme: iconTheme,
      titleTextStyle: typography.englishLike.titleLarge,
      toolbarTextStyle: typography.englishLike.titleLarge,
    ),
    badgeTheme: BadgeThemeData(
      textStyle: typography.englishLike.labelMedium,
    ),
    iconTheme: iconTheme,
    primaryTextTheme: typography.englishLike,
    typography: typography,
  );
}