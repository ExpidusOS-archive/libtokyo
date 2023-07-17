import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/l10n.dart';

const _LEADING_ICON_PADDING_SIZE_MULT = 1.0;
const _ICON_PADDING_SIZE_MULT = 0.25;
const kWindowBarHeight = kToolbarHeight / 2;

class WindowBarTheme extends InheritedWidget {
  const WindowBarTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final WindowBarThemeData data;

  @override
  bool updateShouldNotify(covariant WindowBarTheme oldWidget) => oldWidget.data != data;

  static WindowBarThemeData of(BuildContext context) => maybeOf(context)
    ?? WindowBarThemeData(colorScheme: Theme.of(context).colorScheme);

  static WindowBarThemeData? maybeOf(BuildContext context) =>
    context.findAncestorWidgetOfExactType<WindowBarTheme>()?.data;
}

class WindowBarThemeData {
  factory WindowBarThemeData({
    required ColorScheme colorScheme,
    Color? backgroundColor,
    double? windowBarHeight,
    double? iconSize,
    double? borderRadius,
    TextStyle? titleTextStyle
  }) {
    backgroundColor ??= colorScheme.onSurface;
    borderRadius ??= 15;

    return WindowBarThemeData.raw(
      colorScheme: colorScheme,
      backgroundColor: backgroundColor,
      windowBarHeight: windowBarHeight,
      iconSize: iconSize,
      borderRadius: borderRadius,
      titleTextStyle: titleTextStyle,
    );
  }

  const WindowBarThemeData.raw({
    required this.colorScheme,
    required this.backgroundColor,
    required this.windowBarHeight,
    required this.iconSize,
    required this.borderRadius,
    required this.titleTextStyle,
  });

  final ColorScheme colorScheme;
  final Color backgroundColor;
  final double? windowBarHeight;
  final double? iconSize;
  final double borderRadius;
  final TextStyle? titleTextStyle;
}

class _PreferredWindowBarSize extends Size {
  _PreferredWindowBarSize(this.windowBarHeight)
    : super.fromHeight((windowBarHeight ?? kWindowBarHeight));

  final double? windowBarHeight;
}

class WindowBar extends StatelessWidget implements libtokyo.WindowBar<Key, Widget>, PreferredSizeWidget {
  WindowBar({
    super.key,
    this.leading,
    this.title,
    this.onMinimize,
    this.onMaximize,
    this.onClose,
    this.actions = const [],
    this.iconSize,
    this.windowBarHeight,
    this.useBitsdojo,
  }) : preferredSize = _PreferredWindowBarSize(windowBarHeight);

  final Widget? leading;
  final Widget? title;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onClose;
  final List<Widget> actions;
  final double? iconSize;
  final double? windowBarHeight;
  final bool? useBitsdojo;

  @override
  final Size preferredSize;

  static double preferredHeightFor(BuildContext context, Size preferredSize) {
    if (preferredSize is _PreferredWindowBarSize && preferredSize.windowBarHeight == null) {
      return WindowBarTheme.of(context).windowBarHeight ?? kWindowBarHeight;
    }

    return preferredSize.height;
  }

  bool _shouldUseBitsdojo() {
    if (useBitsdojo != null) return useBitsdojo!;
    if (kIsWeb) return false;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return false;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return true;
    }
  }

  static bool shouldShow(BuildContext context) {
    final theme = Theme.of(context);

    if (kIsWeb) return false;

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return false;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return true;
    }
  }

  List<Widget> _buildActions(BuildContext context, double iconSize) {
    if (actions.isNotEmpty) return actions;
    final i18n = GlobalTokyoLocalizations.of(context);

    var list = <Widget>[];
    if (onMinimize != null || _shouldUseBitsdojo()) {
      list.add(IconButton(
        icon: const Icon(Icons.minimize),
        iconSize: iconSize,
        tooltip: i18n == null ? 'Minimize' : i18n.windowbarMinimize,
        onPressed: onMinimize ?? appWindow.minimize,
      ));
    }

    if (onMaximize != null || _shouldUseBitsdojo()) {
      list.add(IconButton(
        icon: const Icon(Icons.maximize),
        iconSize: iconSize,
        tooltip: i18n == null ? 'Maximize' : i18n.windowbarMaximize,
        onPressed: onMaximize ?? appWindow.maximizeOrRestore,
      ));
    }

    if (onClose != null || _shouldUseBitsdojo()) {
      list.add(IconButton(
        icon: const Icon(Icons.close),
        iconSize: iconSize,
        tooltip: i18n == null ? 'Close' : i18n.windowbarClose,
        onPressed: onClose ?? appWindow.close,
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final windowBarTheme = WindowBarTheme.of(context);

    final height = windowBarHeight ?? windowBarTheme.windowBarHeight ?? kWindowBarHeight;
    final iconUnits = iconSize ?? windowBarTheme.iconSize ?? IconTheme.of(context).size ?? 24;
    
    final iconSizeResolved = (iconUnits / height) * 15;
    final iconPadding = iconSizeResolved * _ICON_PADDING_SIZE_MULT;

    final leadingIconSize = (iconUnits / height) * 20;
    final leadingIconPadding = iconSizeResolved * _LEADING_ICON_PADDING_SIZE_MULT;

    Widget widget = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: windowBarTheme.backgroundColor,
      leading: leading != null ? Padding(
        padding: EdgeInsets.symmetric(vertical: iconPadding, horizontal: leadingIconPadding),
        child: leading!,
      ) : null,
      leadingWidth: leading != null ? (leadingIconPadding * 2.0) + leadingIconSize : null,
      titleSpacing: 0.0,
      title: title,
      titleTextStyle: windowBarTheme.titleTextStyle ?? Theme.of(context).textTheme.labelMedium,
      toolbarHeight: height,
      shape: (_shouldUseBitsdojo() && !appWindow.isMaximized) ? RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(windowBarTheme.borderRadius),
          topRight: Radius.circular(windowBarTheme.borderRadius),
        ),
      ) : null,
      actions: _buildActions(context, iconSizeResolved),
    );

    if (_shouldUseBitsdojo()) {
      return MoveWindow(child: widget);
    }
    return widget;
  }
}
