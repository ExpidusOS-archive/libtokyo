import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/logic.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'package:filesize/filesize.dart';
import 'dart:io' as io;

class FileBrowserListEntry extends StatelessWidget implements libtokyo.FileBrowserListEntry<Key, Widget> {
  const FileBrowserListEntry({
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
    Widget? iconWidget = null;
    if (showIcon) {
      if (icon == null) {
        if (entry is io.File) {
          iconWidget = Icon(
            Icons.text_snippet,
            size: iconSize,
          );
        } else if (entry is io.Directory) {
          iconWidget = Icon(
            Icons.folder,
            size: iconSize,
          );
        } else if (entry is io.Link) {
          iconWidget = Icon(
            Icons.attachment,
            size: iconSize,
          );
        }
      } else {
        iconWidget = icon!;
      }
    }

    final locale = Localizations.localeOf(context).toString().replaceAll('-', '_');
    return FutureBuilder<io.FileStat>(
      future: entry.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text(snapshot.error!.toString());
        if (snapshot.hasData) {
          final data = snapshot.data!;

          return InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            onSecondaryTap: onLongPress,
            child: ListTile(
              leading: iconWidget,
              title: Text(path.basename(entry.path)),
              subtitle: Text(DateFormat.yMd().add_jm().format(data.changed)),
              trailing: entry is io.File ? Text(filesize(data.size)) : null,
              enabled: enabled,
              selected: selected,
            ),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }
}
