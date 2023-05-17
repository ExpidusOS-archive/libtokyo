import 'package:test/test.dart';
import 'package:libtokyo/color.dart';

final String _TEST_COLOR = 'a1b2c3d4';

void testColor(Color color, double red, double green, double blue, double alpha, String str) {
  expect(color.red, red);
  expect(color.green, green);
  expect(color.blue, blue);
  expect(color.alpha, alpha);

  expect(color[0], color.red);
  expect(color[1], color.green);
  expect(color[2], color.blue);
  expect(color[3], color.alpha);

  expect(color.toString(), str);
}

void main() {
  test('Color.fromString with starting #', () {
    final color = Color.fromString('#${_TEST_COLOR}');
    testColor(color, 0xa1 / 255, 0xb2 / 255, 0xc3 / 255, 0xd4 / 255, "#${_TEST_COLOR}");
  });

  test('Color.fromString without starting #', () {
    final color = Color.fromString('${_TEST_COLOR}');
    testColor(color, 0xa1 / 255, 0xb2 / 255, 0xc3 / 255, 0xd4 / 255, "#${_TEST_COLOR}");
  });

  test('Color.fromJSON', () {
    final color = Color.fromJSON('"#${_TEST_COLOR}"');
    testColor(color, 0xa1 / 255, 0xb2 / 255, 0xc3 / 255, 0xd4 / 255, "#${_TEST_COLOR}");
  });
}
