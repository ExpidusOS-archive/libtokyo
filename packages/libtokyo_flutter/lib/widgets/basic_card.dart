import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class BasicCard extends StatelessWidget implements libtokyo.BasicCard<Key, Widget> {
  const BasicCard({
    super.key,
    this.color,
    this.title,
    this.message,
    this.titleStyle,
  });

  final libtokyo.Color? color;
  final String? title;
  final String? message;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (title != null) children.add(Text(title!, style: titleStyle ?? Theme.of(context).textTheme.headlineMedium));
    if (message != null) children.add(Text(message!));

    return Card(
      color: color == null ? null : convertColor(color!),
      child: Column(
        children: children,
      ),
    );
  }
}
