import 'package:libtokyo/logic.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TokyoApp<Key, Widget extends Object, Route extends Object> {
  const TokyoApp({
    this.theme,
    this.colorScheme,
    this.key,
    this.title = '',
    this.home
  });

  final ThemeData? theme;
  final ColorScheme? colorScheme;
  final Key? key;
  final String title;
  final Widget? home;
}

abstract mixin class TokyoAppState<Key, Widget extends Object, Route extends Object> {
  late final ThemeData theme;
  TokyoApp<Key, Widget, Route> get tokyoWidget;

  ColorScheme get colorScheme => tokyoWidget.theme != null ? tokyoWidget.theme!.colorScheme : (tokyoWidget.colorScheme != null ? tokyoWidget.colorScheme! : ColorScheme.night);

  Future<String> loadThemeJSON(ColorScheme colorScheme);

  Future<void> updateTheme() async {
    theme = ThemeData.json(
      package: 'libtokyo',
      colorScheme: colorScheme,
      json: await loadThemeJSON(colorScheme),
    );
    print(theme);
  }
}
