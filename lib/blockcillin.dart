library blockcillin;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;

part 'src/app.dart';
part 'src/app_controller.dart';
part 'src/app_state.dart';
part 'src/block.dart';
part 'src/block_color.dart';
part 'src/block_gl.dart';
part 'src/board.dart';
part 'src/board_program.dart';
part 'src/board_renderer.dart';
part 'src/button_bar.dart';
part 'src/cell.dart';
part 'src/fader.dart';
part 'src/game.dart';
part 'src/game_view.dart';
part 'src/gl.dart';
part 'src/main_menu.dart';
part 'src/math.dart';
part 'src/matrix4.dart';
part 'src/quaternion.dart';
part 'src/ring.dart';
part 'src/selector_program.dart';
part 'src/selector_renderer.dart';
part 'src/state.dart';
part 'src/texture.dart';
part 'src/vector2.dart';
part 'src/vector3.dart';

void run() {
  new AppController().run();
}