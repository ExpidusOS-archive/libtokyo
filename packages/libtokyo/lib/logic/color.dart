import 'dart:convert';

enum ColorChannel {
  red,
  green,
  blue,
  alpha
}

class Color {
  const Color(int value) :
    red = ((0x000000ff & value) >> 0) / 255,
    green = ((0x0000ff00 & value) >> 8) / 255,
    blue = ((0x00ff0000 & value) >> 16) / 255,
    alpha = ((0xff000000 & value) >> 24) / 255;
  const Color.rgb(this.red, this.green, this.blue) : alpha = 1.0;
  const Color.rgba(this.red, this.green, this.blue, this.alpha);

  final double red;
  final double green;
  final double blue;
  final double alpha;
  int get value => int.parse('${_toStringChannel(0)}${_toStringChannel(1)}${_toStringChannel(2)}${_toStringChannel(3)}', radix: 16);

  @override
  int get hashCode => value.hashCode;

  String _toStringChannel(int i) {
    final value = (this[i] * 255).toInt().toRadixString(16);
    return value.length < 2 ? '0${value}' : value;
  }

  @override
  String toString() => '#${_toStringChannel(0)}${_toStringChannel(1)}${_toStringChannel(2)}${_toStringChannel(3)}';

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
    if (str[0] == '#') {
      print(str);
      return Color.fromString(str.substring(1, str.length));
    }

    assert(str.length % 2 == 0);

    final channelCount = str.length / 2;
    var channels = List<double>.filled(4, 0);
    channels[3] = 1.0;

    for (var i = 0; i < channelCount; i++) {
      channels[i] = _parseChannel(str.substring(i * 2, (i * 2) + 2));
    }

    return Color.rgba(channels[0], channels[1], channels[2], channels[3]);
  }
}
