import 'package:libtokyo/libtokyo.dart' as libtokyo;
import 'package:libtokyo_flutter/libtokyo.dart';
import 'package:flutter/services.dart';

class TokyoApp extends StatefulWidget implements libtokyo.TokyoApp<Key, Widget, Route, BuildContext> {
  const TokyoApp({
    super.key,
    this.title = '',
    this.initialRoute = '/',
    this.theme,
    this.colorScheme,
    this.darkTheme,
    this.colorSchemeDark,
    this.themeMode = ThemeMode.system,
    this.home,
    this.routerConfig,
    this.routerDelegate,
    this.builder,
    this.scrollBehavior,
    this.routes = const <String, WidgetBuilder>{},
    this.onGenerateTitle,
    this.navigatorObservers,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
  });

  final libtokyo.ThemeData? theme;
  final libtokyo.ColorScheme? colorScheme;
  final libtokyo.ThemeData? darkTheme;
  final libtokyo.ColorScheme? colorSchemeDark;
  final ThemeMode themeMode;
  final String title;
  final String initialRoute;
  final Widget? home;
  final RouterConfig? routerConfig;
  final RouterDelegate<Object>? routerDelegate;
  final TransitionBuilder? builder;
  final ScrollBehavior? scrollBehavior;
  final Map<String, WidgetBuilder> routes;
  final GenerateAppTitle? onGenerateTitle;
  final List<NavigatorObserver>? navigatorObservers;
  final Iterable<Locale> supportedLocales;
  final Locale? locale;
  final Iterable<LocalizationsDelegate>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;

  @override
  State<TokyoApp> createState() => _TokyoAppState();
}

class _TokyoAppState extends State<TokyoApp> with libtokyo.TokyoAppState<Key, Widget, Route, BuildContext> {
  @override
  libtokyo.TokyoApp<Key, Widget, Route, BuildContext> get tokyoWidget => widget;

  @override
  Future<String> loadThemeJSON(libtokyo.ColorScheme colorScheme) =>
    rootBundle.loadString("packages/libtokyo/data/themes/${colorScheme.name}.json");

  libtokyo.ThemeData _resolveTheme(BuildContext context, libtokyo.TokyoAppTheme data) {
    switch (widget.themeMode) {
      case ThemeMode.dark:
        return data.dark;
      case ThemeMode.light:
        return data.light;
      case ThemeMode.system:
        switch (MediaQuery.platformBrightnessOf(context)) {
          case Brightness.dark:
            return data.dark;
          case Brightness.light:
            return data.light;
        }
    }
  }

  @override
  Widget build(BuildContext context) =>
    FutureBuilder(
      future: loadTheme(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          FlutterError.reportError(FlutterErrorDetails(
            exception: snapshot.error!,
            library: 'libtokyo_flutter',
            context: ErrorSummary('Failed to update theme'),
          ));
        }

        if (snapshot.hasData) {
          final activeTheme = _resolveTheme(context, snapshot.data!);
          return MaterialApp(
            color: convertColor(activeTheme.backgroundColor),
            theme: convertThemeData(snapshot.data!.light, Brightness.light),
            darkTheme: convertThemeData(snapshot.data!.dark, Brightness.dark),
            themeMode: widget.themeMode,
            title: widget.title,
            initialRoute: widget.initialRoute,
            onGenerateTitle: widget.onGenerateTitle,
            home: widget.home,
            builder: widget.builder,
            routes: widget.routes.map((key, value) => MapEntry(key, value)),
            navigatorObservers: widget.navigatorObservers ?? [],
            supportedLocales: (widget.supportedLocales ?? []).toList()..addAll(
              GlobalTokyoLocalizations.supportedLocales..removeWhere((locale) => (widget.supportedLocales ?? []).contains(locale))
            ),
            locale: widget.locale,
            localizationsDelegates: (widget.localizationsDelegates ?? []).toList()..addAll([
              GlobalTokyoLocalizations.delegate
            ]),
            localeListResolutionCallback: widget.localeListResolutionCallback,
            localeResolutionCallback: widget.localeResolutionCallback,
          );
        }

        return const CircularProgressIndicator();
      },
    );
}
