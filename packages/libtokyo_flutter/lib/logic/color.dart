import 'package:libtokyo/libtokyo.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

ui.Color convertColor(Color source) => ui.Color.fromARGB(
  (source.alpha * 255).round(),
  (source.red * 255).round(),
  (source.green * 255).round(),
  (source.blue * 255).round()
);

MaterialColor convertColorMaterial(List<Color> sources) => MaterialColor(
  convertColor(sources[0]).value,
  sources.sublist(1).asMap().map((key, value) => MapEntry(
    (key + 1) * 100,
    convertColor(value)
  ))
);
