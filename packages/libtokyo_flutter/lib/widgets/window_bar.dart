import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:flutter/material.dart';

final _LEADING_ICON_PADDING_SIZE_MULT = 1.0;
final _ICON_PADDING_SIZE_MULT = 0.25;

class WindowBar extends StatelessWidget implements libtokyo.WindowBar<Key, Widget>, PreferredSizeWidget {
  const WindowBar({
    super.key,
    this.leading,
    this.title,
    this.onMinimize,
    this.onMaximize,
    this.onClose,
  });

  final Widget? leading;
  final Widget? title;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onClose;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight / 2);

  @override
  Widget build(BuildContext context) {
    final height = AppBar.preferredHeightFor(context, Size.fromHeight(kToolbarHeight)) / 2;
    
    final iconSize = ((IconTheme.of(context).size ?? 24) / height) * 15;
    final iconPadding = iconSize * _ICON_PADDING_SIZE_MULT;

    final leadingIconSize = ((IconTheme.of(context).size ?? 24) / height) * 20;
    final leadingIconPadding = iconSize * _LEADING_ICON_PADDING_SIZE_MULT;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      leading: leading != null ? Padding(
        padding: EdgeInsets.symmetric(vertical: iconPadding, horizontal: leadingIconPadding),
        child: leading!,
      ) : null,
      leadingWidth: leading != null ? (leadingIconPadding * 2.0) + leadingIconSize : null,
      titleSpacing: 0.0,
      title: title,
      titleTextStyle: Theme.of(context).textTheme.labelMedium,
      toolbarHeight: height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.minimize),
          iconSize: iconSize,
          tooltip: 'Minimize',
          onPressed: onMinimize ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.maximize),
          iconSize: iconSize,
          tooltip: 'Mazimize',
          onPressed: onMaximize ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.close),
          iconSize: iconSize,
          tooltip: 'Close',
          onPressed: onClose ?? () {},
        ),
      ],
    );
  }
}
