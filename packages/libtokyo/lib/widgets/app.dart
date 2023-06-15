import 'package:libtokyo/logic.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TokyoApp<Key, Widget extends Object, Route extends Object, BuildContext> {
  const TokyoApp({
    this.theme,
    this.colorScheme,
    this.darkTheme,
    this.colorSchemeDark,
    this.key,
    this.title = '',
    this.initialRoute = '/',
    this.home,
    this.onGenerateTitle,
    required this.routes,
  });

  final ThemeData? theme;
  final ColorScheme? colorScheme;
  final ThemeData? darkTheme;
  final ColorScheme? colorSchemeDark;

  final Key? key;
  final String title;
  final String initialRoute;
  final Widget? home;
  final String Function(BuildContext context)? onGenerateTitle;
  final Map<String, Widget Function(BuildContext context)> routes;
}

class TokyoAppTheme {
  const TokyoAppTheme({
    required this.dark,
    required this.light,
  });

  final ThemeData dark;
  final ThemeData light;
}

abstract mixin class TokyoAppState<Key, Widget extends Object, Route extends Object, BuildContext> {
  TokyoApp<Key, Widget, Route, BuildContext> get tokyoWidget;

  ColorScheme get colorScheme => tokyoWidget.theme != null ? tokyoWidget.theme!.colorScheme : (tokyoWidget.colorScheme != null ? tokyoWidget.colorScheme! : ColorScheme.day);
  ColorScheme get colorSchemeDark => tokyoWidget.darkTheme != null ? tokyoWidget.darkTheme!.colorScheme : (tokyoWidget.colorSchemeDark != null ? tokyoWidget.colorSchemeDark! : ColorScheme.night);

  Future<String> loadThemeJSON(ColorScheme colorScheme);

  Future<ThemeData> _loadThemeSingle(bool dark) async {
    final value = dark ? colorSchemeDark : colorScheme;
    final loaded = dark ? tokyoWidget.darkTheme : tokyoWidget.theme;
    return loaded ?? ThemeData.json(
      package: 'libtokyo',
      colorScheme: value,
      json: await loadThemeJSON(value),
    );
  }

  Future<TokyoAppTheme> loadTheme() async {
    return TokyoAppTheme(
      dark: await _loadThemeSingle(true),
      light: await _loadThemeSingle(false)
    );
  }
}
