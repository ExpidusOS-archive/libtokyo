import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/logic.dart';
import 'package:libtokyo_flutter/icons.dart';
import 'package:flutter/material.dart' hide Icons, Icon;
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'package:filesize/filesize.dart';
import 'dart:io' as io;

class FileBrowserGridEntry extends StatelessWidget implements libtokyo.FileBrowserGridEntry<Key, Widget> {
  const FileBrowserGridEntry({
    super.key,
    this.showIcon = true,
    this.iconSize,
    this.icon,
    required this.entry,
    this.enabled = true,
    this.selected = false,
    this.onTap,
    this.onLongPress,
  });

  final bool showIcon;
  final double? iconSize;
  final Widget? icon;
  final io.FileSystemEntity entry;
  final bool enabled;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

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
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      onSecondaryTap: onLongPress,
      child: GridTile(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
