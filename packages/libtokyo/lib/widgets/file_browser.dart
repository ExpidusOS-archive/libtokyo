import 'package:libtokyo/logic.dart';
import 'package:libtokyo/types.dart';
import 'package:meta/meta.dart';
import 'dart:io' as io;

typedef FileBrowserFilter = bool Function(io.FileSystemEntity entity);
typedef FileBrowserCreateLoadingWidget<Widget extends Object, BuildContext> = Widget Function(BuildContext context);
typedef FileBrowserCreateEntryWidget<Widget extends Object> = Widget Function(io.FileSystemEntity entity);
typedef FileBrowserCreateErrorWidget<Widget extends Object> = Widget Function(Error e);
typedef FileBrowserOnSelection = void Function(io.FileSystemEntity entity);
typedef FileBrowserOnDeselection = void Function(io.FileSystemEntity entity);

enum FileBrowserMode {
  sync,
  async,
  stream,
}

@immutable
abstract class FileBrowser<Key, Widget extends Object, BuildContext> {
  const FileBrowser({
    this.key,
    this.allowMultipleSelections = false,
    this.allowBrowsingUp = false,
    this.recursive = false,
    this.followLinks = true,
    this.mode = FileBrowserMode.async,
    required this.directory,
    this.createLoadingWidget,
    this.createEntryWidget,
    this.createErrorWidget,
    this.filter,
    this.onSelection,
    this.onDeselection,
  });

  final Key? key;
  final bool allowMultipleSelections;
  final bool allowBrowsingUp;
  final bool recursive;
  final bool followLinks;
  final FileBrowserMode mode;
  final io.Directory directory;
  final FileBrowserCreateLoadingWidget<Widget, BuildContext>? createLoadingWidget;
  final FileBrowserCreateEntryWidget<Widget>? createEntryWidget;
  final FileBrowserCreateErrorWidget<Widget>? createErrorWidget;
  final FileBrowserFilter? filter;
  final FileBrowserOnSelection? onSelection;
  final FileBrowserOnDeselection? onDeselection;
}

@immutable
abstract mixin class FileBrowserState<Key, Widget extends Object, BuildContext> {
  FileBrowser<Key, Widget, BuildContext> get fileBrowserWidget;

  late List<io.FileSystemEntity> selections;
  late io.Directory currentDirectory;

  @protected
  void initFileBrowserState() {
    selections = <io.FileSystemEntity>[];
    currentDirectory = fileBrowserWidget.directory;
  }

  @protected
  bool filterFileBrowser(io.FileSystemEntity entry) => (fileBrowserWidget.filter ?? (entry) => true)(entry);

  @protected
  Widget createFileBrowserLoadingWidget(BuildContext context) =>
    (fileBrowserWidget.createLoadingWidget ?? (context) {
      throw UnimplementedError("FileBrowserState.createLoadingWidget is not implemented and createLoadingWidget is not set in widget.");
    })(context);

  @protected
  Widget createFileBrowserEntryWidget(io.FileSystemEntity entry) =>
    (fileBrowserWidget.createEntryWidget ?? (entry) {
      throw UnimplementedError("FileBrowserState.createFileBrowserEntryWidget is not implemented and createEntryWidget is not set in widget.");
    })(entry);

  @protected
  Widget createFileBrowserErrorWidget(Error e) =>
    (fileBrowserWidget.createErrorWidget ?? (entry) {
      throw UnimplementedError("FileBrowserState.createFileBrowserErrorWidget is not implemented and createErrorWidget is not set in widget.");
    })(e);

  @protected
  Stream<Widget> buildFileBrowserWidgetsStream(io.Directory? dir, { bool? recursive, bool? followLinks }) =>
    dir == null ? buildFileBrowserWidgetsStream(
        currentDirectory,
        recursive: recursive,
        followLinks: followLinks
      )
    : dir!.list(
        recursive: recursive ?? fileBrowserWidget.recursive,
        followLinks: followLinks ?? fileBrowserWidget.followLinks,
      ).where(filterFileBrowser)
       .map<Widget>((entry) => createFileBrowserEntryWidget(entry));

  @protected
  Future<List<Widget>> buildFileBrowserWidgetsAsync(io.Directory? dir, { bool? recursive, bool? followLinks }) =>
    dir == null ? buildFileBrowserWidgetsAsync(
        currentDirectory,
        recursive: recursive,
        followLinks: followLinks
      )
    : buildFileBrowserWidgetsStream(
        dir,
        recursive: recursive,
        followLinks: followLinks,
      ).toList();

  @protected
  List<Widget> buildFileBrowserWidgetsSync(io.Directory? dir, { bool? recursive, bool? followLinks }) =>
    dir == null ? buildFileBrowserWidgetsSync(
        currentDirectory,
        recursive: recursive,
        followLinks: followLinks,
      )
    : dir!.listSync(
        recursive: recursive ?? fileBrowserWidget.recursive,
        followLinks: followLinks ?? fileBrowserWidget.followLinks,
      ).where(filterFileBrowser)
       .map<Widget>((entry) => createFileBrowserEntryWidget(entry)).toList();

  @protected
  Widget createFileBrowserWidget(BuildContext context, io.Directory? dir, { bool? recursive, bool? followLinks });
}
