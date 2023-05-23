import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/logic.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

class FileBrowserEntry extends StatelessWidget implements libtokyo.FileBrowserEntry<Key, Widget> {
  const FileBrowserEntry({
    super.key,
    this.showIcon = true,
    this.iconSize,
    this.direction = Axis.vertical,
    required this.entry,
  });

  final bool showIcon;
  final double? iconSize;
  final Axis direction;
  final io.FileSystemEntity entry;

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];

    if (showIcon) {
      if (entry is io.File) {
        children.add(Icon(
          Icons.text_snippet,
          size: iconSize,
        ));
      } else if (entry is io.Directory) {
        children.add(Icon(
          Icons.folder,
          size: iconSize,
        ));
      } else if (entry is io.Link) {
        children.add(Icon(
          Icons.attachment,
          size: iconSize,
        ));
      }
    }

    children.add(Text(path.basename(entry.path)));
    return Flex(
      direction: direction,
      children: children,
    );
  }
}
