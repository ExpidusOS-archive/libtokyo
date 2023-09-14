import 'dart:convert';

import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:flutter/material.dart' hide Icons, Icon;
import 'package:google_fonts/google_fonts.dart';
import '../icons.dart';
import '../widgets.dart';
import 'color.dart';

Brightness _inverseBrightness(Brightness brightness) => brightness == Brightness.light ? Brightness.dark : Brightness.light;

TextStyle applyTextStyle(TextStyle base, libtokyo.ThemeData source, [Brightness brightness = Brightness.light]) {
  final color = convertColor(brightness == Brightness.light ? source.foregroundColor : source.gutterForegroundColor);
  return GoogleFonts.notoSans(
    color: color,
    textStyle: base.copyWith(inherit: true),
  );
}

TextTheme applyTextTheme(TextTheme base, libtokyo.ThemeData source, [Brightness brightness = Brightness.light]) {
  final color = convertColor(brightness == Brightness.light ? source.foregroundColor : source.gutterForegroundColor);
  final gbase = GoogleFonts.notoSansTextTheme(base);
  return TextTheme(
    displayLarge: applyTextStyle(gbase.displayLarge!, source, brightness),
    displayMedium: applyTextStyle(gbase.displayMedium!, source, brightness),
    displaySmall: applyTextStyle(gbase.displaySmall!, source, brightness),
    headlineLarge: applyTextStyle(gbase.headlineLarge!, source, brightness),
    headlineMedium: applyTextStyle(gbase.headlineMedium!, source, brightness),
    headlineSmall: applyTextStyle(gbase.headlineSmall!, source, brightness),
    titleLarge: applyTextStyle(gbase.titleLarge!, source, brightness),
    titleMedium: applyTextStyle(gbase.titleMedium!, source, brightness),
    titleSmall: applyTextStyle(gbase.titleSmall!, source, brightness),
    bodyLarge: applyTextStyle(gbase.bodyLarge!, source, brightness),
    bodyMedium: applyTextStyle(gbase.bodyMedium!, source, brightness),
    bodySmall: applyTextStyle(gbase.bodySmall!, source, brightness),
    labelLarge: applyTextStyle(gbase.labelLarge!, source, brightness),
    labelMedium: applyTextStyle(gbase.labelMedium!, source, brightness),
    labelSmall: applyTextStyle(gbase.labelSmall!, source, brightness),
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
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) => const Icon(Icons.angleLeft),
      closeButtonIconBuilder: (context) => const Icon(Icons.xmark),
      drawerButtonIconBuilder: (context) => const Icon(Icons.bars),
      endDrawerButtonIconBuilder: (context) => const Icon(Icons.bars),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.primary,
      iconTheme: iconTheme,
      actionsIconTheme: iconTheme,
      titleTextStyle: typography.englishLike.titleLarge,
      toolbarTextStyle: typography.englishLike.titleLarge,
    ),
    listTileTheme: ListTileThemeData(
      textColor: colorScheme.primary,
      iconColor: colorScheme.primary,
    ),
    badgeTheme: BadgeThemeData(
      textStyle: typography.englishLike.labelMedium,
    ),
    iconTheme: iconTheme,
    primaryTextTheme: typography.englishLike,
    textTheme: typography.englishLike,
    typography: typography,
  );
}
