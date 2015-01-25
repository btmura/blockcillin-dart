library test;

import 'dart:html';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:web_gl' as webgl;
import 'package:typed_mock/typed_mock.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';

import 'package:blockcillin/client.dart';

part 'src/app_test.dart';
part 'src/app_controller_test.dart';
part 'src/app_view_test.dart';
part 'src/block_test.dart';
part 'src/board_test.dart';
part 'src/button_bar_test.dart';
part 'src/cell_test.dart';
part 'src/game_test.dart';
part 'src/game_view_test.dart';
part 'src/gl_program_test.dart';
part 'src/gl_test.dart';
part 'src/main_menu_test.dart';
part 'src/mocks.dart';
part 'src/quaternion_test.dart';
part 'src/ring_test.dart';
part 'src/vector2_test.dart';
part 'src/vector3_test.dart';

void main() {
  useHtmlEnhancedConfiguration();

  _app_tests();
  _app_controller_tests();
  _app_view_tests();
  _block_tests();
  _board_tests();
  _button_bar_tests();
  _cell_tests();
  _game_tests();
  _game_view_tests();
  _gl_program_tests();
  _gl_tests();
  _main_menu_tests();
  _quaternion_tests();
  _ring_tests();
  _vector2_tests();
  _vector3_tests();
}