library test;

import 'dart:html';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:typed_mock/typed_mock.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';

import 'package:blockcillin/client.dart';

part 'src/block_test.dart';
part 'src/board_test.dart';
part 'src/button_bar_test.dart';
part 'src/cell_test.dart';
part 'src/game_test.dart';
part 'src/gl_program_test.dart';
part 'src/gl_test.dart';
part 'src/mocks.dart';
part 'src/quaternion_test.dart';
part 'src/ring_test.dart';
part 'src/vector2_test.dart';
part 'src/vector3_test.dart';

void main() {
  useHtmlEnhancedConfiguration();

  _block_tests();
  _board_tests();
  _button_bar_tests();
  _cell_tests();
  _game_tests();
  _gl_program_tests();
  _gl_tests();
  _quaternion_tests();
  _ring_tests();
  _vector2_tests();
  _vector3_tests();
}