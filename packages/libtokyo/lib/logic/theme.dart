import 'dart:convert';
import 'color.dart';

enum ColorScheme {
  storm,
  night,
  moon,
  day,
}

class ThemeData {
  const ThemeData.raw({
    required this.colorScheme,
    required this.package,
    required this.darkBackgroundColor,
    required this.backgroundColor,
    required this.darkSurfaceColor,
    required this.surfaceColor,
    required this.darkForegroundColor,
    required this.gutterForegroundColor,
    required this.foregroundColor,
    required this.blueColors,
    required this.redColors,
  });

  factory ThemeData.json({
    required ColorScheme colorScheme,
    String? package,
    required String json,
  }) {
    final data = jsonDecode(json);
    return ThemeData.raw(
      colorScheme: colorScheme,
      package: package,
      darkBackgroundColor: Color.fromString(data['darkBackgroundColor']),
      backgroundColor: Color.fromString(data['backgroundColor']),
      darkSurfaceColor: Color.fromString(data['darkSurfaceColor']),
      surfaceColor: Color.fromString(data['surfaceColor']),
      darkForegroundColor: Color.fromString(data['darkForegroundColor']),
      gutterForegroundColor: Color.fromString(data['gutterForegroundColor']),
      foregroundColor: Color.fromString(data['foregroundColor']),
      blueColors: data['blueColors'].map<Color>((color) => Color.fromString(color)).toList(),
      redColors: data['redColors'].map<Color>((color) => Color.fromString(color)).toList(),
    );
  }

  final ColorScheme colorScheme;
  final String? package;
  final Color darkBackgroundColor;
  final Color backgroundColor;
  final Color darkSurfaceColor;
  final Color surfaceColor;
  final Color darkForegroundColor;
  final Color gutterForegroundColor;
  final Color foregroundColor;
  final List<Color> blueColors;
  final List<Color> redColors;

  @override
  String toString() => jsonEncode({
    'package': package,
    'colorScheme': colorScheme.name,
    'darkBackgroundColor': darkBackgroundColor.toString(),
    'backgroundColor': backgroundColor.toString(),
    'darkSurfaceColor': darkSurfaceColor.toString(),
    'surfaceColor': surfaceColor.toString(),
    'darkForegroundColor': darkForegroundColor.toString(),
    'gutterForegroundColor': gutterForegroundColor.toString(),
    'foregroundColor': foregroundColor.toString(),
    'blueColors': blueColors.map((color) => color.toString()).toList(),
    'redColors': redColors.map((color) => color.toString()).toList(),
  });
}
