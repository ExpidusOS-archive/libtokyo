import 'package:libtokyo/logic.dart';
import 'package:libtokyo/types.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WindowBar<Key, Widget extends Object> {
  const WindowBar({
    this.key,
    this.leading,
    this.title,
    this.onMinimize,
    this.onMaximize,
    this.onClose,
    this.actions = const [],
  });
  
  final Key? key;
  final Widget? leading;
  final Widget? title;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onClose;
  final List<Widget> actions;
}
