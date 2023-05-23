import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'file_browser.dart';
import 'file_browser_grid_entry.dart';

class FileBrowserGrid extends FileBrowser {
  const FileBrowserGrid({
    super.key,
    super.recursive,
    super.followLinks,
    super.mode,
    required super.directory,
    super.createLoadingWidget,
    super.createEntryWidget,
    super.createErrorWidget,
    super.filter,
    super.onTap,
    super.onLongPress,
    required this.gridDelegate,
  });

  final SliverGridDelegate gridDelegate;

  @override
  State<FileBrowser> createState() => _FileBrowserGridState();
}

class _FileBrowserGridState extends FileBrowserState {
  @override
  Widget createFileBrowserEntryWidget(BuildContext context, io.FileSystemEntity entry) {
    if (widget.createEntryWidget != null) {
      return widget.createEntryWidget!(entry);
    }

    return FileBrowserGridEntry(
      entry: entry,
      onTap: widget.onTap != null ? () => widget.onTap!(entry) : null,
      onLongPress: widget.onLongPress != null ? () => widget.onLongPress!(entry) : null,
    );
  }

  @override
  Widget buildFileBrowser(BuildContext context, AsyncSnapshot<List<Widget>> snapshot) =>
    snapshot.hasData ? GridView(
      gridDelegate: (widget as FileBrowserGrid).gridDelegate,
      children: snapshot.data!
    ) : super.buildFileBrowser(context, snapshot);
}
