import 'dart:html';

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_controller.dart';
import 'package:blockcillin/src/app_view.dart';
import 'package:blockcillin/src/board_renderer.dart';
import 'package:blockcillin/src/button_bar.dart';
import 'package:blockcillin/src/game_view.dart';
import 'package:blockcillin/src/gl.dart';
import 'package:blockcillin/src/gl_program.dart';
import 'package:blockcillin/src/main_menu.dart';

main() {

  // Construct the button bar's DOM tree and add it to the body.

  ButtonElement pauseButton = new ButtonElement()
      ..text = "Pause";

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

  var mainMenu = new MainMenu();

  var buttonBar = new ButtonBar(buttonBarElement, pauseButton);

  var program = new GLProgram(gl);

  var boardRenderer = new BoardRenderer(program);

  var gameView = new GameView(buttonBar, canvas, gl, program, boardRenderer);

  var appView = new AppView(mainMenu, gameView);

  var appController = new AppController(app, appView);

  appController.run();
}
