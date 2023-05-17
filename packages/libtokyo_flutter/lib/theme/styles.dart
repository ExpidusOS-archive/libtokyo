import 'package:flutter/material.dart' show ColorScheme;

import 'styles/base.dart';
import 'styles/night.dart';
import 'styles/night-storm.dart';
import 'styles/night-light.dart';

enum TokyoStyle {
  night(impl: const TokyoNightStyle()),
  nightStorm(impl: const TokyoNightStormStyle()),
  nightLight(impl: const TokyoNightLightStyle());

  const TokyoStyle({required this.impl});

  final TokyoBaseStyle impl;
}
