import 'package:libtokyo/types.dart';
import 'package:meta/meta.dart';
import 'dart:io' as io;
import 'file_browser_entry.dart';

@immutable
abstract class FileBrowserGridEntry<Key, Widget extends Object> extends FileBrowserEntry<Key, Widget> {
  const FileBrowserGridEntry({
    super.key,
    super.showIcon,
    super.iconSize,
    super.icon,
    required super.entry,
    this.enabled = true,
    this.selected = false,
    this.onTap,
    this.onLongPress,
  });

  final bool enabled;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
}
