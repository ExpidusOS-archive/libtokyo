import 'package:libtokyo/theme/styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

class LibTokyoThemeData {
  const LibTokyoThemeData._();

  static ThemeData night({String? fontFamily}) => TokyoStyle.night.impl.create(fontFamily: fontFamily);
  static ThemeData nightStorm({String? fontFamily}) => TokyoStyle.nightStorm.impl.create(fontFamily: fontFamily);
  static ThemeData nightLight({String? fontFamily}) => TokyoStyle.nightLight.impl.create(fontFamily: fontFamily);
}
