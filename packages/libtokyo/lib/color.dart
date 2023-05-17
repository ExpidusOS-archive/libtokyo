import 'dart:convert';

enum ColorChannel {
  red,
  green,
  blue,
  alpha
}

class Color {
  const Color(this.red, this.green, this.blue, this.alpha);

  final double red;
  final double green;
  final double blue;
  final double alpha;

  String _toStringChannel(int i) => ((this[i] * 255) as int).toRadixString(16);

  @override
  String toString() => "#${_toStringChannel(0)}${_toStringChannel(1)}${_toStringChannel(2)}${_toStringChannel(3)}";

  @override
  operator ==(Object obj) {
    if (obj is Color) {
      return red == obj.red && green == obj.green && blue == obj.blue && alpha == obj.alpha;
    }
    return false;
  }

  operator [](int i) {
    switch (i) {
      case 0:
        return red;
      case 1:
        return green;
      case 2:
        return blue;
      case 3:
        return alpha;
      default:
        throw RangeError.index(i, this, "Color", "color channel does not exist at index", 4);
    }
  }

  static Color fromJSON(String json) => Color.fromString(jsonDecode(json));

  static int _parseChannelToInt(String str) {
    assert(str.length == 2);
    return int.parse(str, radix: 16);
  }

  static double _parseChannel(String str) => _parseChannelToInt(str) / 255;

  static Color fromString(String str) {
    if (str.length == 5 || str.length == 7) {
      return Color.fromString(str.substring(1, str.length));
    }

    assert(str.length <= 6 && str.isNotEmpty);

    final channelCount = str.length / 2;
    var channels = List<double>.filled(4, 0);
    channels[3] = 1.0;

    for (var i = 0; i < channelCount; i++) {
      channels[i] = _parseChannel(str.substring(i * 2, (i * 2) + 2));
    }

    return Color(channels[0], channels[1], channels[2], channels[3]);
  }
}
