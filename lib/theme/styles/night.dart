import 'package:flutter/material.dart';
import 'dart:ui' show Brightness;
import 'base.dart';

class TokyoNightStyle extends TokyoBaseStyle {
  const TokyoNightStyle();

  @override
  Color getPrimaryColor() => Color(0xff1a1b26);

  @override
  Color getSecondaryColor() => Color(0xff414868);

  @override
  Color getTertiaryColor() => Color(0xfff7768e);

  @override
  Color getNeutralColor() => Color(0xffc5c3c7);

  @override
  Color getErrorColor() => Color(0xfff7768e);

  @override
  Color getDisabledColor() => Color(0xff565f89);

  @override
  Color getHighlightColor() => Color(0x40515c7e);

  @override
  Color getHintColor() => Color(0x0da0ba);

  @override
  Color getHoverColor() => Color(0xaa3d59a1);

  @override
  Color getTextColor() => Color(0xffa9b1d6);

  @override
  Brightness getBrightness() => Brightness.dark;

  @override
  ButtonStyle getButtonStyle() => ButtonStyle(
    visualDensity: VisualDensity.standard,
    backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.hovered)) {
        return Color(0xaa3d59a1);
      }
      return Color(0xdd3d59a1);
    }),
    foregroundColor: MaterialStateProperty.resolveWith<Color?>((_) {
      return Color(0xffffffff);
    }),
  );

  @override
  AppBarTheme getAppBarTheme() => super.getAppBarTheme().copyWith(
    backgroundColor: Color(0xff16161e),
    foregroundColor: Color(0xff787c99),
  );

  @override
  SwitchThemeData getSwitchTheme() => super.getSwitchTheme().copyWith(
    thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
      if (states.contains(MaterialState.pressed)) {
        return Color(0xff2ac3de);
      }

      return Color(0xff9aa5ce);
    }),
  );
}
