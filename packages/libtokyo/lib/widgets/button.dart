import 'package:color/color.dart';
import 'package:libtokyo/logic.dart';
import 'package:libtokyo/types.dart';
import 'package:meta/meta.dart';

mixin ButtonStyleButton<T extends Object> {
  final VoidCallback? onPressed = null;
  final VoidCallback? onLongPress = null;
  final VoidCallback? onHover = null;
  final VoidCallback? onFocusChange = null;
  final ButtonStyle? style = null;
  final TokyoStatesController? statesController = null;
  final T? child = null;

  bool get enabled => onPressed != null || onLongPress != null;
}

@immutable
class ButtonStyle {
  const ButtonStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.elevation,
  });

  final TokyoStateProperty<Color?>? backgroundColor;
  final TokyoStateProperty<Color?>? foregroundColor;
  final TokyoStateProperty<Color?>? shadowColor;
  final TokyoStateProperty<double?>? elevation;
}
