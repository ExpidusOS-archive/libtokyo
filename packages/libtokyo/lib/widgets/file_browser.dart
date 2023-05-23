import 'package:libtokyo/logic.dart';
import 'package:libtokyo/types.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

typedef FileBrowserFilter = bool Function(io.FileSystemEntity entity);
typedef FileBrowserSort = int Function(io.FileSystemEntity a, io.FileSystemEntity b);
typedef FileBrowserCreateLoadingWidget<Widget extends Object, BuildContext> = Widget Function(BuildContext context);
typedef FileBrowserCreateEntryWidget<Widget extends Object> = Widget Function(io.FileSystemEntity entity);
typedef FileBrowserCreateErrorWidget<Widget extends Object> = Widget Function(Error e);
typedef FileBrowserOnTap<Widget extends Object> = void Function(io.FileSystemEntity entity);
typedef FileBrowserOnLongPress<Widget extends Object> = void Function(io.FileSystemEntity entity);

enum FileBrowserMode {
  sync,
  async,
  stream,
}

@immutable
abstract class FileBrowser<Key, Widget extends Object, BuildContext> {
  const FileBrowser({
    this.key,
    this.recursive = false,
    this.followLinks = true,
    this.showHidden = false,
    this.mode = FileBrowserMode.async,
    required this.directory,
    this.createLoadingWidget,
    this.createEntryWidget,
    this.createErrorWidget,
    this.filter,
    this.sort,
    this.onTap,
    this.onLongPress,
  });

  final Key? key;
  final bool recursive;
  final bool followLinks;
  final bool showHidden;
  final FileBrowserMode mode;
  final io.Directory directory;
  final FileBrowserCreateLoadingWidget<Widget, BuildContext>? createLoadingWidget;
  final FileBrowserCreateEntryWidget<Widget>? createEntryWidget;
  final FileBrowserCreateErrorWidget<Widget>? createErrorWidget;
  final FileBrowserFilter? filter;
  final FileBrowserSort? sort;
  final FileBrowserOnTap<Widget>? onTap;
  final FileBrowserOnLongPress<Widget>? onLongPress;
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
  bool filterFileBrowser(io.FileSystemEntity entry) {
    if (path.basename(entry.path).startsWith('.')) {
      return fileBrowserWidget.showHidden;
    }

    return (fileBrowserWidget.filter ?? (entry) => true)(entry);
  }

  @protected
  int sortFileBrowser(io.FileSystemEntity a, io.FileSystemEntity b) {
    final pathCompare = a.path.compareTo(b.path);
    final typeCompare = a.statSync().type.toString().compareTo(b.statSync().type.toString());
    return typeCompare == 0 ? pathCompare : typeCompare;
  }

  @protected
  Widget createFileBrowserLoadingWidget(BuildContext context) =>
    (fileBrowserWidget.createLoadingWidget ?? (context) {
      throw UnimplementedError("FileBrowserState.createLoadingWidget is not implemented and createLoadingWidget is not set in widget.");
    })(context);

  @protected
  Widget createFileBrowserEntryWidget(BuildContext context, io.FileSystemEntity entry) =>
    (fileBrowserWidget.createEntryWidget ?? (entry) {
      throw UnimplementedError("FileBrowserState.createFileBrowserEntryWidget is not implemented and createEntryWidget is not set in widget.");
    })(entry);

  @protected
  Widget createFileBrowserErrorWidget(BuildContext context, Error e) =>
    (fileBrowserWidget.createErrorWidget ?? (entry) {
      throw UnimplementedError("FileBrowserState.createFileBrowserErrorWidget is not implemented and createErrorWidget is not set in widget.");
    })(e);

  @protected
  Stream<Widget> buildFileBrowserWidgetsStream(BuildContext context, io.Directory? dir, { bool? recursive, bool? followLinks }) =>
    dir == null ? buildFileBrowserWidgetsStream(
        context, currentDirectory,
        recursive: recursive,
        followLinks: followLinks
      )
    : Stream<Widget>.multi((controller) =>
      dir!.list(
        recursive: recursive ?? fileBrowserWidget.recursive,
        followLinks: followLinks ?? fileBrowserWidget.followLinks,
      ).where(filterFileBrowser).toList().then((entries) {
        entries.sort(sortFileBrowser);

        final widgets = entries.map<Widget>((entry) => createFileBrowserEntryWidget(context, entry)).toList();
        for (var widget in widgets) {
          controller.add(widget);
        }

        controller.close();
      }).catchError((e) => controller.addError(e)));

  @protected
  Future<List<Widget>> buildFileBrowserWidgetsAsync(BuildContext context, io.Directory? dir, { bool? recursive, bool? followLinks }) =>
    dir == null ? buildFileBrowserWidgetsAsync(
        context, currentDirectory,
        recursive: recursive,
        followLinks: followLinks
      )
    : buildFileBrowserWidgetsStream(
        context, dir,
        recursive: recursive,
        followLinks: followLinks,
      ).toList();

  @protected
  List<Widget> buildFileBrowserWidgetsSync(BuildContext context, io.Directory? dir, { bool? recursive, bool? followLinks }) =>
    dir == null ? buildFileBrowserWidgetsSync(
        context, currentDirectory,
        recursive: recursive,
        followLinks: followLinks,
      )
    : (dir!.listSync(
        recursive: recursive ?? fileBrowserWidget.recursive,
        followLinks: followLinks ?? fileBrowserWidget.followLinks,
      ).where(filterFileBrowser).toList()
       ..sort(sortFileBrowser))
       .map<Widget>((entry) => createFileBrowserEntryWidget(context, entry)).toList();

  @protected
  Widget createFileBrowserWidget(BuildContext context, io.Directory? dir, { bool? recursive, bool? followLinks });
}
