import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'file_browser.dart';
import 'file_browser_list_entry.dart';

class FileBrowserList extends FileBrowser {
  const FileBrowserList({
    super.key,
    super.recursive,
    super.followLinks,
    super.showHidden,
    super.mode,
    required super.directory,
    super.createLoadingWidget,
    super.createEntryWidget,
    super.createErrorWidget,
    super.filter,
    super.onTap,
    super.onLongPress,
  });

  @override
  State<FileBrowser> createState() => _FileBrowserListState();
}

class _FileBrowserListState extends FileBrowserState {
  @override
  Widget createFileBrowserEntryWidget(BuildContext context, io.FileSystemEntity entry) {
    if (widget.createEntryWidget != null) {
      return widget.createEntryWidget!(entry);
    }

    return FileBrowserListEntry(
      entry: entry,
      onTap: widget.onTap != null ? () => widget.onTap!(entry) : null,
      onLongPress: widget.onLongPress != null ? () => widget.onLongPress!(entry) : null,
    );
  }

  @override
  Widget buildFileBrowser(BuildContext context, AsyncSnapshot<List<Widget>> snapshot) =>
    snapshot.hasData ? ListView(children: snapshot.data!)
      : super.buildFileBrowser(context, snapshot);
}
