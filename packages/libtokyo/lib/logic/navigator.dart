/**
 * Based on https://github.com/flutter/flutter/blob/d3d8effc68/packages/flutter/lib/src/widgets/navigator.dart
 */

import 'package:meta/meta.dart';
import 'change_notifier.dart';

@immutable
class RouteSettings {
  const RouteSettings({
    this.name,
    this.arguments,
  });

  final String? name;
  final Object? arguments;
}

typedef RouteFactory<Route extends Object> = Route? Function(RouteSettings settings);
