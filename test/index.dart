library test;

import 'dart:math' as math;
import 'dart:typed_data';
import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';

import 'package:blockcillin/blockcillin.dart';

part 'src/block_test.dart';
part 'src/board_test.dart';
part 'src/cell_test.dart';
part 'src/game_test.dart';
part 'src/quaternion_test.dart';
part 'src/ring_test.dart';
part 'src/vector2_test.dart';
part 'src/vector3_test.dart';

void main() {
  useHtmlEnhancedConfiguration();

  _block_tests();
  _board_tests();
  _cell_tests();
  _game_tests();
  _quaternion_tests();
  _ring_tests();
  _vector2_tests();
  _vector3_tests();
}