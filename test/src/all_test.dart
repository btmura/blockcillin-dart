library tests;

import 'dart:async';
import 'dart:html';
import 'package:unittest/html_enhanced_config.dart';
import 'package:unittest/unittest.dart';

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_controller.dart';
import 'package:blockcillin/src/app_view.dart';
import 'package:blockcillin/src/block.dart';
import 'package:blockcillin/src/board.dart';
import 'package:blockcillin/src/cell.dart';
import 'package:blockcillin/src/game.dart';
import 'package:blockcillin/src/gl.dart';
import 'package:blockcillin/src/main_menu.dart';
import 'package:blockcillin/src/ring.dart';

part 'app_test.dart';
part 'app_controller_test.dart';
part 'app_view_test.dart';
part 'block_test.dart';
part 'board_test.dart';
part 'cell_test.dart';
part 'game_test.dart';
part 'gl_test.dart';
part 'main_menu_test.dart';
part 'ring_test.dart';

main() {
  useHtmlEnhancedConfiguration();

  app_tests();
  app_controller_tests();
  app_view_tests();
  block_tests();
  board_tests();
  cell_tests();
  game_tests();
  gl_tests();
  main_menu_tests();
  ring_tests();
}