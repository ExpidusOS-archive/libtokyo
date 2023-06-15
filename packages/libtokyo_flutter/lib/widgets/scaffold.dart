import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:flutter/material.dart' as material;
import 'package:libtokyo_flutter/logic.dart';

class Scaffold extends material.StatelessWidget implements libtokyo.Scaffold<material.Key, material.Widget, material.PreferredSizeWidget> {
  const Scaffold({
    super.key,
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

  final material.PreferredSizeWidget? windowBar;
  final material.PreferredSizeWidget? appBar;
  final libtokyo.Color? backgroundColor;
  final material.Widget? body;
  final material.Widget? bottomNavigationBar;
  final material.Widget? bottomSheet;
  final material.Widget? drawer;
  final material.Widget? endDrawer;
  final bool extendBody;
  final material.Widget? floatingActionButton;
  final libtokyo.DrawerCallback? onDrawerChanged;
  final libtokyo.DrawerCallback? onEndDrawerChanged;
  final List<material.Widget>? persistentFooterButtons;
  final bool? resizeToAvoidBottomInset;

  @override
  material.Widget build(material.BuildContext context) =>
    material.Scaffold(
      key: key,
      appBar: windowBar,
      backgroundColor: material.Colors.transparent,
      primary: false,
      extendBody: extendBody,
      body: material.Scaffold(
        appBar: appBar,
        backgroundColor: backgroundColor != null ? convertColor(backgroundColor!) : material.Theme.of(context).backgroundColor,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        drawer: drawer,
        endDrawer: endDrawer,
        extendBody: true,
        floatingActionButton: floatingActionButton,
        onDrawerChanged: onDrawerChanged,
        onEndDrawerChanged: onEndDrawerChanged,
        persistentFooterButtons: persistentFooterButtons,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        primary: true,
      ),
    );
}
