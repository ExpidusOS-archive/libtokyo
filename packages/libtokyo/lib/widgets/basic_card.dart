import 'package:libtokyo/logic.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BasicCard<Key, Widget extends Object> {
  const BasicCard({
    this.key,
    this.color,
    this.title,
    this.message,
  });

  final Key? key;
  final Color? color;
  final String? title;
  final String? message;
}
