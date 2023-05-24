import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:flutter/material.dart';
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
    black: applyTextTheme(Typography.blackMountainView, source, Brightness.dark),
    white: applyTextTheme(Typography.whiteMountainView, source, Brightness.light),
    englishLike: applyTextTheme(Typography.englishLike2021, source, _inverseBrightness(brightness)),
    dense: applyTextTheme(Typography.dense2021, source, brightness),
    tall: applyTextTheme(Typography.tall2021, source, brightness),
  );

  final iconTheme = IconThemeData(
    color: convertColor(source.foregroundColor),
  );

  return ThemeData.from(
    colorScheme: colorScheme,
    textTheme: typography.englishLike,
  ).copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: convertColor(source.surfaceColor),
      foregroundColor: convertColor(source.foregroundColor),
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
