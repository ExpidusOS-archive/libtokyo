import 'package:libtokyo/logic.dart';
import 'package:libtokyo/types.dart';
import 'package:meta/meta.dart';

@immutable
abstract class Scaffold<Key, Widget extends Object, PreferredSizeWidget extends Widget> {
  const Scaffold({
    this.key,
    this.windowBar,
    this.appBar,
    this.backgroundColor,
    this.body,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.drawer,
    this.endDrawer,
    this.extendBody = false,
    this.floatingActionButton,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.persistentFooterButtons,
    this.resizeToAvoidBottomInset,
  });

  final Key? key;
  final PreferredSizeWidget? windowBar;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool extendBody;
  final Widget? floatingActionButton;
  final DrawerCallback? onDrawerChanged;
  final DrawerCallback? onEndDrawerChanged;
  final List<Widget>? persistentFooterButtons;
  final bool? resizeToAvoidBottomInset;
}
