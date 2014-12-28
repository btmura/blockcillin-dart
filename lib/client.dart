library client;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;

part 'src/app.dart';
part 'src/app_controller.dart';
part 'src/app_view.dart';
part 'src/block.dart';
part 'src/board.dart';
part 'src/board_renderer.dart';
part 'src/button_bar.dart';
part 'src/cell.dart';
part 'src/fader.dart';
part 'src/game.dart';
part 'src/game_view.dart';
part 'src/gl.dart';
part 'src/gl_program.dart';
part 'src/main_menu.dart';
part 'src/matrix4.dart';
part 'src/quaternion.dart';
part 'src/ring.dart';
part 'src/vector3.dart';

void client_main() {
  // Construct the button bar's DOM tree and add it to the body.

  ButtonElement pauseButton = new ButtonElement()
      ..text = "Pause"
      ..className = "game-menu-button";

  DivElement buttonBarElement = new DivElement()
      ..className = "button-bar"
      ..append(pauseButton);

  document.body.children.add(buttonBarElement);

  // Add canvas after button bar. Some code relies on this order.

  var canvas = new CanvasElement()
      ..className = "canvas";

  document.body.children.add(canvas);

  var gl = getWebGL(canvas);
  if (gl == null) {
    // TODO(btmura): handle when WebGL isn't supported
    return;
  }

  var app = new App();

  var mainMenu = new MainMenu.withElements();

  var buttonBar = new ButtonBar(buttonBarElement, pauseButton);

  var program = new GLProgram(gl);

  var boardRenderer = new BoardRenderer(program);

  var gameView = new GameView(buttonBar, canvas, gl, program, boardRenderer);

  var appView = new AppView(mainMenu, gameView);

  var appController = new AppController(app, appView);

  appController.run();
}