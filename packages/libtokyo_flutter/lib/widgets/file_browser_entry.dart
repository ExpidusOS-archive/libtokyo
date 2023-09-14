import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/logic.dart';
import 'package:libtokyo_flutter/icons.dart';
import 'package:flutter/material.dart' hide Icons, Icon;
import 'package:path/path.dart' as path;
import 'dart:io' as io;

class FileBrowserEntry extends StatelessWidget implements libtokyo.FileBrowserEntry<Key, Widget> {
  const FileBrowserEntry({
    super.key,
    this.showIcon = true,
    this.iconSize,
    this.direction = Axis.vertical,
    this.icon,
    required this.entry,
  });

  final bool showIcon;
  final double? iconSize;
  final Axis direction;
  final Widget? icon;
  final io.FileSystemEntity entry;

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    if (showIcon) {
      if (icon == null) {
        if (entry is io.File) {
          children.add(Icon(
            Icons.fileLines,
            size: iconSize,
          ));
        } else if (entry is io.Directory) {
          children.add(Icon(
            Icons.folder,
            size: iconSize,
          ));
        } else if (entry is io.Link) {
          children.add(Icon(
            Icons.link,
            size: iconSize,
          ));
        }
      } else {
        children.add(icon!);
      }
    }

    children.add(Text(path.basename(entry.path)));
    return Flex(
      direction: direction,
      children: children,
    );
  }
}
