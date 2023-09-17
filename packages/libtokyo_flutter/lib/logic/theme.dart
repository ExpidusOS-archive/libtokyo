import 'dart:convert';

import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:flutter/material.dart' hide Icons, Icon;
import 'package:google_fonts/google_fonts.dart';
import '../icons.dart';
import '../widgets.dart';
import 'color.dart';

Brightness _inverseBrightness(Brightness brightness) => brightness == Brightness.light ? Brightness.dark : Brightness.light;

TextStyle _styleForContext(BuildContext context, TextStyle textStyle) {
  final locale = Localizations.localeOf(context);
  switch (locale.languageCode) {
    case 'ja':
      return GoogleFonts.zenMaruGothic(textStyle: textStyle);
  }
  return GoogleFonts.saira(textStyle: textStyle);
}

TextTheme _themeForContext(BuildContext context, TextTheme base) {
  final locale = Localizations.localeOf(context);
  switch (locale.languageCode) {
    case 'ja':
      return GoogleFonts.zenMaruGothicTextTheme(base);
  }
  return GoogleFonts.sairaTextTheme(base);
}

TextStyle applyTextStyle({
  required BuildContext context,
  required TextStyle base,
  required libtokyo.ThemeData source,
  Brightness brightness = Brightness.light,
}) {
  final color = convertColor(brightness == Brightness.light ? source.foregroundColor : source.gutterForegroundColor);
  return _styleForContext(context, base.copyWith(inherit: true)).copyWith(
    color: color,
  );
}

TextTheme applyTextTheme({
  required BuildContext context,
  required TextTheme base,
  required libtokyo.ThemeData source,
  Brightness brightness = Brightness.light,
}) {
  final color = convertColor(brightness == Brightness.light ? source.foregroundColor : source.gutterForegroundColor);
  final gbase = _themeForContext(context, base);
  return TextTheme(
    displayLarge: applyTextStyle(
      context: context,
      base: gbase.displayLarge!,
      source: source,
      brightness: brightness,
    ),
    displayMedium: applyTextStyle(
      context: context,
      base: gbase.displayMedium!,
      source: source,
      brightness: brightness,
    ),
    displaySmall: applyTextStyle(
      context: context,
      base: gbase.displaySmall!,
      source: source,
      brightness: brightness,
    ),
    headlineLarge: applyTextStyle(
      context: context,
      base: gbase.headlineLarge!,
      source: source,
      brightness: brightness,
    ),
    headlineMedium: applyTextStyle(
      context: context,
      base: gbase.headlineMedium!,
      source: source,
      brightness: brightness,
    ),
    headlineSmall: applyTextStyle(
      context: context,
      base: gbase.headlineSmall!,
      source: source,
      brightness: brightness,
    ),
    titleLarge: applyTextStyle(
      context: context,
      base: gbase.titleLarge!,
      source: source,
      brightness: brightness,
    ),
    titleMedium: applyTextStyle(
      context: context,
      base: gbase.titleMedium!,
      source: source,
      brightness: brightness,
    ),
    titleSmall: applyTextStyle(
      context: context,
      base: gbase.titleSmall!,
      source: source,
      brightness: brightness,
    ),
    bodyLarge: applyTextStyle(
      context: context,
      base: gbase.bodyLarge!,
      source: source,
      brightness: brightness,
    ),
    bodyMedium: applyTextStyle(
      context: context,
      base: gbase.bodyMedium!,
      source: source,
      brightness: brightness,
    ),
    bodySmall: applyTextStyle(
      context: context,
      base: gbase.bodySmall!,
      source: source,
      brightness: brightness,
    ),
    labelLarge: applyTextStyle(
      context: context,
      base: gbase.labelLarge!,
      source: source,
      brightness: brightness,
    ),
    labelMedium: applyTextStyle(
      context: context,
      base: gbase.labelMedium!,
      source: source,
      brightness: brightness,
    ),
    labelSmall: applyTextStyle(
      context: context,
      base: gbase.labelSmall!,
      source: source,
      brightness: brightness,
    ),
  ).apply(
    displayColor: color,
    bodyColor: color,
  );
}

ThemeData convertThemeData({
  required BuildContext context,
  required libtokyo.ThemeData source,
  Brightness brightness = Brightness.light
}) {
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

  final borderColor = Color.lerp(colorScheme.background, colorScheme.surface, 0.5)!;

  final typography = Typography.material2021(
    colorScheme: colorScheme,
    black: applyTextTheme(
      context: context,
      base: Typography.blackMountainView,
      source: source,
      brightness: Brightness.dark,
    ),
    white: applyTextTheme(
      context: context,
      base: Typography.whiteMountainView,
      source: source,
      brightness: Brightness.light,
    ),
    englishLike: applyTextTheme(
      context: context,
      base: Typography.englishLike2021,
      source: source,
      brightness: _inverseBrightness(brightness),
    ),
    dense: applyTextTheme(
      context: context,
      base: Typography.dense2021,
      source: source,
      brightness: _inverseBrightness(brightness),
    ),
    tall: applyTextTheme(
      context: context,
      base: Typography.tall2021,
      source: source,
      brightness: _inverseBrightness(brightness),
    ),
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
      shadowColor: Colors.transparent,
      elevation: 0.0,
    ),
    listTileTheme: ListTileThemeData(
      textColor: colorScheme.primary,
      iconColor: colorScheme.primary,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: colorScheme.background,
      textStyle: typography.englishLike.labelMedium,
      labelTextStyle: MaterialStateProperty.all(typography.englishLike.labelMedium),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    badgeTheme: BadgeThemeData(
      textStyle: typography.englishLike.labelMedium,
    ),
    navigationRailTheme: NavigationRailThemeData(
      elevation: 0.0,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.background,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: typography.englishLike.labelMedium,
    ),
    applyElevationOverlayColor: false,
    shadowColor: Colors.transparent,
    iconTheme: iconTheme,
    primaryTextTheme: typography.englishLike,
    textTheme: typography.englishLike,
    typography: typography,
  );
}
