import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show MaterialApp;

class TokyoApp extends StatefulWidget implements libtokyo.TokyoApp<Key, Widget, Route> {
  const TokyoApp({
    super.key,
    this.title = '',
    this.theme,
    this.colorScheme,
    this.home,
    this.routerConfig,
    this.routerDelegate,
    this.builder,
    this.scrollBehavior,
  });

  final libtokyo.ThemeData? theme;
  final libtokyo.ColorScheme? colorScheme;
  final String title;
  final Widget? home;
  final RouterConfig? routerConfig;
  final RouterDelegate<Object>? routerDelegate;
  final TransitionBuilder? builder;
  final ScrollBehavior? scrollBehavior;

  @override
  State<TokyoApp> createState() => _TokyoAppState();
}

class _TokyoAppState extends State<TokyoApp> with libtokyo.TokyoAppState<Key, Widget, Route> {
  libtokyo.TokyoApp<Key, Widget, Route> get tokyoWidget => widget;

  Future<String> loadThemeJSON(libtokyo.ColorScheme colorScheme) =>
    rootBundle.loadString("packages/libtokyo/data/themes/${colorScheme.name}.json");

  @override
  void initState() {
    super.initState();

    updateTheme().catchError((err) =>
      FlutterError.reportError(FlutterErrorDetails(
        exception: err,
        library: 'libtokyo_flutter',
        context: ErrorSummary('Failed to update theme'),
      )));
  }

  Widget _tokyoBuilder(BuildContext context, Widget? child) {
    return DefaultSelectionStyle(
      child: widget.builder != null ?
        Builder(
          builder: (context) => widget.builder!(context, child),
        ) : child ?? const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) =>
    MaterialApp();
}
