import 'dart:convert';

import 'color.dart';

class ThemeData {
  const ThemeData();

  static ThemeData fromJSON(String json) => ThemeData();
}

class Theme {
  const Theme(this.scheme, this.data);

  final ColorScheme scheme;
  final ThemeData data;

  static Theme fromJSON(ColorScheme scheme, String json) =>
      Theme(scheme, ThemeData.fromJSON(json));
}
