import 'package:libtokyo/logic.dart';

interface class TokyoApp<T extends Object> {
  const TokyoApp({
    this.home,
    this.title = '',
  });

  final T? home;
  final String title;
}

mixin class TokyoAppState<T extends Object> {}
