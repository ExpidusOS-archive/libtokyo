import 'dart:convert';

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
  });

  factory ThemeData.json({
    required ColorScheme colorScheme,
    String? package,
    required String json,
  }) {
    final data = jsonDecode(json);
    print(data);
    return ThemeData.raw(
      colorScheme: colorScheme,
      package: package,
    );
  }

  final ColorScheme colorScheme;
  final String? package;

  @override
  String toString() => jsonEncode({
    'package': package,
    'colorScheme': colorScheme.name,
  });
}
