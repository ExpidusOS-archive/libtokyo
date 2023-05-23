import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:developer' show log;
import 'file_browser_entry.dart';

abstract class FileBrowser extends StatefulWidget implements libtokyo.FileBrowser<Key, Widget, BuildContext> {
  const FileBrowser({
    super.key,
    this.allowMultipleSelections = false,
    this.allowBrowsingUp = false,
    this.recursive = false,
    this.followLinks = true,
    this.mode = libtokyo.FileBrowserMode.async,
    required this.directory,
    this.createLoadingWidget,
    this.createEntryWidget,
    this.createErrorWidget,
    this.filter,
    this.onSelection,
    this.onDeselection,
  });

  final bool allowMultipleSelections;
  final bool allowBrowsingUp;
  final bool recursive;
  final bool followLinks;
  final libtokyo.FileBrowserMode mode;
  final io.Directory directory;
  final libtokyo.FileBrowserCreateLoadingWidget<Widget, BuildContext>? createLoadingWidget;
  final libtokyo.FileBrowserCreateEntryWidget<Widget>? createEntryWidget;
  final libtokyo.FileBrowserCreateErrorWidget<Widget>? createErrorWidget;
  final libtokyo.FileBrowserFilter? filter;
  final libtokyo.FileBrowserOnSelection? onSelection;
  final libtokyo.FileBrowserOnDeselection? onDeselection;
}

@immutable
abstract class FileBrowserState extends State<FileBrowser> with libtokyo.FileBrowserState<Key, Widget, BuildContext> {
  libtokyo.FileBrowser<Key, Widget, BuildContext> get fileBrowserWidget => widget;
  List<Widget>? _streamedWidgets;

  @override
  Widget createFileBrowserLoadingWidget(BuildContext context) =>
    (widget.createLoadingWidget ?? (context) => CircularProgressIndicator())(context);

  @override
  Widget createFileBrowserEntryWidget(io.FileSystemEntity entry) =>
    (widget.createEntryWidget ?? (entry) => FileBrowserEntry(entry: entry))(entry);

  @override
  Widget createFileBrowserErrorWidget(Error e) =>
    (widget.createErrorWidget ?? (e) => Text(e.toString()))(e);

  @mustCallSuper
  void initState() {
    super.initState();
    initFileBrowserState();
  }

  @mustCallSuper
  Widget buildFileBrowser(BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
    if (snapshot.hasError) return createFileBrowserErrorWidget(snapshot.error! as Error);
    if (snapshot.hasData) {
      throw UnimplementedError("FileBrowserState.buildFileBrowser is not implemented to handle ready data.");
    }
    return createFileBrowserLoadingWidget(context);
  }

  Widget createFileBrowserWidget(BuildContext context, io.Directory? dir, { bool? recursive, bool? followLinks }) {
    switch (widget.mode) {
      case libtokyo.FileBrowserMode.sync:
        if (kDebugMode) {
          log('It is recommended to not use FileBrowserMode.sync as it can cause performance issues.',
            level: 900,
            name: 'libtokyo_flutter',
            stackTrace: StackTrace.current);
        }

        try {
          return buildFileBrowser(context, AsyncSnapshot<List<Widget>>.withData(ConnectionState.done, buildFileBrowserWidgetsSync(
            dir,
            recursive: recursive,
            followLinks: followLinks,
          )));
        } catch (e) {
          return createFileBrowserErrorWidget(e as Error);
        }
      case libtokyo.FileBrowserMode.async:
        return FutureBuilder<List<Widget>>(
          future: buildFileBrowserWidgetsAsync(
            dir,
            recursive: recursive,
            followLinks: followLinks,
          ),
          builder: buildFileBrowser,
        );
      case libtokyo.FileBrowserMode.stream:
        return StreamBuilder<Widget>(
          stream: buildFileBrowserWidgetsStream(
            dir,
            recursive: recursive,
            followLinks: followLinks,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) return createFileBrowserErrorWidget(snapshot.error! as Error);

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                _streamedWidgets = <Widget>[];
              case ConnectionState.waiting:
                return createFileBrowserLoadingWidget(context);
              case ConnectionState.active:
                _streamedWidgets!.add(snapshot.data!);
              case ConnectionState.done:
                return buildFileBrowser(context, AsyncSnapshot<List<Widget>>.withData(snapshot.connectionState, _streamedWidgets ?? <Widget>[]));
            }

            return createFileBrowserLoadingWidget(context);
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) => createFileBrowserWidget(context, null);
}
