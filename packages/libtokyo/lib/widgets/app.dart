import 'package:libtokyo/logic.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TokyoApp<Key, Widget extends Object, Route extends Object, BuildContext> {
  const TokyoApp({
    this.theme,
    this.colorScheme,
    this.key,
    this.title = '',
    this.initialRoute = '/',
    this.home,
    this.onGenerateTitle,
    required this.routes,
  });

  final ThemeData? theme;
  final ColorScheme? colorScheme;
  final Key? key;
  final String title;
  final String initialRoute;
  final Widget? home;
  final String Function(BuildContext context)? onGenerateTitle;
  final Map<String, Widget Function(BuildContext context)> routes;
}

abstract mixin class TokyoAppState<Key, Widget extends Object, Route extends Object, BuildContext> {
  ThemeData? theme = null;
  TokyoApp<Key, Widget, Route, BuildContext> get tokyoWidget;

  ColorScheme get colorScheme => tokyoWidget.theme != null ? tokyoWidget.theme!.colorScheme : (tokyoWidget.colorScheme != null ? tokyoWidget.colorScheme! : ColorScheme.night);

  Future<String> loadThemeJSON(ColorScheme colorScheme);

  Future<ThemeData> updateTheme() async {
    theme = ThemeData.json(
      package: 'libtokyo',
      colorScheme: colorScheme,
      json: await loadThemeJSON(colorScheme),
    );
    return theme!;
  }
}
