import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'file_browser.dart';

class FileBrowserList extends FileBrowser {
  const FileBrowserList({
    super.key,
    super.allowMultipleSelections,
    super.allowBrowsingUp,
    super.recursive,
    super.followLinks,
    super.mode,
    required super.directory,
    super.createLoadingWidget,
    super.createEntryWidget,
    super.createErrorWidget,
    super.filter,
    super.onSelection,
    super.onDeselection,
  });

  @override
  State<FileBrowser> createState() => _FileBrowserListState();
}

class _FileBrowserListState extends FileBrowserState {
  @override
  Widget buildFileBrowser(BuildContext context, AsyncSnapshot<List<Widget>> snapshot) =>
    snapshot.hasData ? ListView(children: snapshot.data!)
      : super.buildFileBrowser(context, snapshot);
}
