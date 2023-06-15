import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:developer' show log;
import 'basic_card.dart';
import 'file_browser_entry.dart';

abstract class FileBrowser extends StatefulWidget implements libtokyo.FileBrowser<Key, Widget, BuildContext> {
  const FileBrowser({
    super.key,
    this.recursive = false,
    this.followLinks = true,
    this.showHidden = false,
    this.mode = libtokyo.FileBrowserMode.async,
    required this.directory,
    this.createLoadingWidget,
    this.createEntryWidget,
    this.createErrorWidget,
    this.filter,
    this.sort,
    this.onTap,
    this.onLongPress,
  });

  final bool recursive;
  final bool followLinks;
  final bool showHidden;
  final libtokyo.FileBrowserMode mode;
  final io.Directory directory;
  final libtokyo.FileBrowserCreateLoadingWidget<Widget, BuildContext>? createLoadingWidget;
  final libtokyo.FileBrowserCreateEntryWidget<Widget>? createEntryWidget;
  final libtokyo.FileBrowserCreateErrorWidget<Widget>? createErrorWidget;
  final libtokyo.FileBrowserFilter? filter;
  final libtokyo.FileBrowserSort? sort;
  final libtokyo.FileBrowserOnTap<Widget>? onTap;
  final libtokyo.FileBrowserOnLongPress<Widget>? onLongPress;
}

@immutable
abstract class FileBrowserState extends State<FileBrowser> with libtokyo.FileBrowserState<Key, Widget, BuildContext> {
  libtokyo.FileBrowser<Key, Widget, BuildContext> get fileBrowserWidget => widget;
  List<Widget>? _streamedWidgets;

  @override
  Widget createFileBrowserLoadingWidget(BuildContext context) =>
    (widget.createLoadingWidget ?? (context) => CircularProgressIndicator())(context);

  @override
  Widget createFileBrowserEntryWidget(BuildContext context, io.FileSystemEntity entry) =>
    (widget.createEntryWidget ?? (entry) => FileBrowserEntry(entry: entry))(entry);

  @override
  Widget createFileBrowserErrorWidget(BuildContext context, Object e) =>
    (widget.createErrorWidget ?? (e) => BasicCard(
      color: convertFromColor(Theme.of(context).colorScheme.onError),
      title: 'Failed to list files',
      message: e.toString()
    ))(e);

  @mustCallSuper
  void initState() {
    super.initState();
    initFileBrowserState();
  }

  @mustCallSuper
  Widget buildFileBrowser(BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
    if (snapshot.hasError) return createFileBrowserErrorWidget(context, snapshot.error!);
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
            context, dir,
            recursive: recursive,
            followLinks: followLinks,
          )));
        } catch (e) {
          return createFileBrowserErrorWidget(context, e as Error);
        }
      case libtokyo.FileBrowserMode.async:
        return FutureBuilder<List<Widget>>(
          future: buildFileBrowserWidgetsAsync(
            context, dir,
            recursive: recursive,
            followLinks: followLinks,
          ),
          builder: buildFileBrowser,
        );
      case libtokyo.FileBrowserMode.stream:
        return StreamBuilder<Widget>(
          stream: buildFileBrowserWidgetsStream(
            context, dir,
            recursive: recursive,
            followLinks: followLinks,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) return createFileBrowserErrorWidget(context, snapshot.error! as Error);

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
