import 'package:flutter/material.dart';
import 'dart:ui' show Brightness;
import 'base.dart';

class TokyoNightLightStyle extends TokyoBaseStyle {
  const TokyoNightLightStyle();

  @override
  Color getPrimaryColor() => Color(0xffd5d6db);

  @override
  Color getSecondaryColor() => Color(0xff0f0f14);

  @override
  Color getTertiaryColor() => Color(0xfff8c4351);

  @override
  Color getNeutralColor() => Color(0xff8a888f);

  @override
  Color getErrorColor() => Color(0xff8c4351);

  @override
  Color getDisabledColor() => Color(0xff9699a3);

  @override
  Color getHighlightColor() => Color(0xfffafbff55);

  @override
  Color getHintColor() => Color(0x0da0ba);

  @override
  Color getHoverColor() => Color(0xaa34548a);

  @override
  Color getTextColor() => Color(0xff565a6e);

  @override
  ButtonStyle getButtonStyle() => ButtonStyle(
    visualDensity: VisualDensity.standard,
    backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.hovered)) {
        return Color(0xaa34548a);
      }
      return Color(0xdd34548);
    }),
    foregroundColor: MaterialStateProperty.resolveWith<Color?>((_) {
      return getTextColor();
    }),
  );

  @override
  AppBarTheme getAppBarTheme() => super.getAppBarTheme().copyWith(
    backgroundColor: Color(0xffcbccd1),
    foregroundColor: Color(0xff4c505e),
  );

  @override
  SwitchThemeData getSwitchTheme() => super.getSwitchTheme().copyWith(
    thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.pressed)) {
        return Color(0xff166775);
      }

      return Color(0xff565a6e);
    }),
  );
}
