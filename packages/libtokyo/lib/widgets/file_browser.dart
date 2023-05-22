import 'package:libtokyo/logic.dart';
import 'package:libtokyo/types.dart';
import 'package:meta/meta.dart';
import 'dart:io' as io;

typedef FileBrowserFilter = bool Function(io.FileSystemEntity entity);
typedef FileBrowserCreateEntryWidget<Widget extends Object> = Widget Function(io.FileSystemEntity entity);
typedef FileBrowserOnSelection = void Function(io.FileSystemEntity entity);
typedef FileBrowserOnDeselection = void Function(io.FileSystemEntity entity);

@immutable
abstract class FileBrowser<Key, Widget extends Object> {
  const FileBrowser({
    this.key,
    this.allowMultipleSelections = false,
    this.allowBrowsingUp = false,
    required this.directory,
    this.createEntryWidget,
    this.filter,
    this.onSelection,
    this.onDeselection,
  });

  final Key? key;
  final bool allowMultipleSelections;
  final bool allowBrowsingUp;
  final io.Directory directory;
  final FileBrowserCreateEntryWidget<Widget>? createEntryWidget;
  final FileBrowserFilter? filter;
  final FileBrowserOnSelection? onSelection;
  final FileBrowserOnDeselection? onDeselection;
}

abstract mixin class FileBrowserState<Key, Widget extends Object> {
  FileBrowser<Key, Widget> get fileBrowserWidget;

  late List<io.FileSystemEntity> selections;
  late io.Directory currentDirectory;

  void initFileBrowserState() {
    selections = <io.FileSystemEntity>[];
    currentDirectory = fileBrowserWidget.directory;
  }

  bool filterFileBrowser(io.FileSystemEntity entry) => (fileBrowserWidget.filter ?? (entry) => true)(entry);

  Widget createFileBrowserEntryWidget(io.FileSystemEntity entry) =>
    (fileBrowserWidget.createEntryWidget ?? (entry) {
      throw UnimplementedError("FileBrowserState.createFileBrowserEntryWidget is not implemented and createEntryWidget is not set in widget.");
    })(entry);

  Stream<Widget> buildFileBrowserWidgetsStream(io.Directory? dir, { bool recursive = false, bool followLinks = true }) =>
    dir == null ? buildFileBrowserWidgetsStream(
        currentDirectory,
        recursive: recursive,
        followLinks: followLinks
      )
    : dir!.list(
        recursive: recursive,
        followLinks: followLinks,
      ).where(filterFileBrowser)
       .map<Widget>((entry) => createFileBrowserEntryWidget(entry));

  Future<List<Widget>> buildFileBrowserWidgetsAsync(io.Directory? dir, { bool recursive = false, bool followLinks = true }) =>
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

  List<Widget> buildFileBrowserWidgetsSync(io.Directory? dir, { bool recursive = false, bool followLinks = true }) =>
    dir == null ? buildFileBrowserWidgetsSync(
        currentDirectory,
        recursive: recursive,
        followLinks: followLinks,
      )
    : dir!.listSync(
        recursive: recursive,
        followLinks: followLinks,
      ).where(filterFileBrowser)
       .map<Widget>((entry) => createFileBrowserEntryWidget(entry)).toList();
}
