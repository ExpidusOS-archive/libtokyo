import 'package:test/test.dart';
import 'package:libtokyo/color.dart';

final String _TEST_COLOR = 'a1b2c3d4';

void testColor(Color color, double red, double green, double blue, double alpha, String str) {
  expect(color.red, equals(red));
  expect(color.green, equals(green));
  expect(color.blue, equals(blue));
  expect(color.alpha, equals(alpha));

  expect(color[0], equals(color.red));
  expect(color[1], equals(color.green));
  expect(color[2], equals(color.blue));
  expect(color[3], equals(color.alpha));
  expect(() => color[4], throwsA(isRangeError));

  expect(color.toString(), equals(str));
  expect(color, equals(Color(red, green, blue, alpha)));
}

void main() {
  test('fromString with starting #', () {
    final color = Color.fromString('#${_TEST_COLOR}');

    testColor(color, 0xa1 / 255, 0xb2 / 255, 0xc3 / 255, 0xd4 / 255, "#${_TEST_COLOR}");
  });

  test('fromString without starting #', () {
    final color = Color.fromString('${_TEST_COLOR}');
    testColor(color, 0xa1 / 255, 0xb2 / 255, 0xc3 / 255, 0xd4 / 255, "#${_TEST_COLOR}");
  });

  test('fromJSON', () {
    final color = Color.fromJSON('"#${_TEST_COLOR}"');
    testColor(color, 0xa1 / 255, 0xb2 / 255, 0xc3 / 255, 0xd4 / 255, "#${_TEST_COLOR}");
  });
}
