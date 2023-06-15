/**
  * Based on https://github.com/flutter/flutter/blob/d3d8effc68/packages/flutter/lib/src/material/material_state.dart
 */

import 'package:meta/meta.dart';
import 'change_notifier.dart';
import 'color.dart';

enum TokyoState {
  hovered,
  focused,
  pressed,
  dragged,
  selected,
  scrolledUnder,
  disabled,
  error,
}

typedef TokyoPropertyResolver<T> = T Function(Set<TokyoState> states);

abstract class TokyoStateColor extends Color implements TokyoStateProperty<Color> {
  const TokyoStateColor(super.defaultValue);

  static TokyoStateColor resolveWith(TokyoPropertyResolver<Color> callback) => _TokyoStateColor(callback);

  @override
  Color resolve(Set<TokyoState> states);
}

class _TokyoStateColor extends TokyoStateColor {
  _TokyoStateColor(this._resolve) : super(_resolve(_defaultStates).value);

  final TokyoPropertyResolver<Color> _resolve;

  static const Set<TokyoState> _defaultStates = <TokyoState>{};

  @override
  Color resolve(Set<TokyoState> states) => _resolve(states);
}

abstract class TokyoStateProperty<T> {
  T resolve(Set<TokyoState> states);

  static T resolveAs<T>(T value, Set<TokyoState> states) {
    if (value is TokyoStateProperty<T>) {
      final TokyoStateProperty<T> property = value;
      return property.resolve(states);
    }
    return value;
  }

  static TokyoStateProperty<T> resolveWith<T>(TokyoPropertyResolver<T> callback) => _TokyoStatePropertyWith<T>(callback);
  static TokyoStateProperty<T> all<T>(T value) => TokyoStatePropertyAll<T>(value);

  static TokyoStateProperty<T?>? lerp<T>(
    TokyoStateProperty<T>? a,
    TokyoStateProperty<T>? b,
    double t,
    T? Function(T?, T?, double) lerpFunction
  ) {
    if (a == null && b == null) return null;

    return _LerpProperties<T>(a, b, t, lerpFunction);
  }
}

class _LerpProperties<T> implements TokyoStateProperty<T?> {
  const _LerpProperties(this.a, this.b, this.t, this.lerpFunction);

  final TokyoStateProperty<T>? a;
  final TokyoStateProperty<T>? b;
  final double t;
  final T? Function(T?, T?, double) lerpFunction;

  @override
  T? resolve(Set<TokyoState> states) {
    final T? resolvedA = a?.resolve(states);
    final T? resolvedB = b?.resolve(states);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}

class _TokyoStatePropertyWith<T> implements TokyoStateProperty<T> {
  _TokyoStatePropertyWith(this._resolve);

  final TokyoPropertyResolver<T> _resolve;

  @override
  T resolve(Set<TokyoState> states) => _resolve(states);
}

class TokyoStatePropertyAll<T> implements TokyoStateProperty<T> {
  const TokyoStatePropertyAll(this.value);

  final T value;

  @override
  T resolve(Set<TokyoState> states) => value;

  @override
  String toString() => 'TokyoStatePropertyAll($value)';
}

class TokyoStatesController extends ValueNotifier<Set<TokyoState>> {
  TokyoStatesController([Set<TokyoState>? value]) : super(<TokyoState>{...?value});

  void update(TokyoState state, bool add) {
    final bool valueChanged = add ? value.add(state) : value.remove(state);
    if (valueChanged) {
      notifyListeners();
    }
  }
}
