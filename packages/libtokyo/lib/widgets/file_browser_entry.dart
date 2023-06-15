import 'package:meta/meta.dart';
import 'dart:io' as io;

@immutable
abstract class FileBrowserEntry<Key, Widget extends Object> {
  const FileBrowserEntry({
    this.key,
    this.showIcon = true,
    this.iconSize,
    this.icon,
    required this.entry,
  });

  final Key? key;
  final bool showIcon;
  final double? iconSize;
  final Widget? icon;
  final io.FileSystemEntity entry;
}
