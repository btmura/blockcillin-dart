import 'dart:html';

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/app_controller.dart';
import 'package:blockcillin/src/app_view.dart';
import 'package:blockcillin/src/board_renderer.dart';
import 'package:blockcillin/src/button_bar.dart';
import 'package:blockcillin/src/game_view.dart';
import 'package:blockcillin/src/gl_canvas.dart';
import 'package:blockcillin/src/gl_program.dart';
import 'package:blockcillin/src/main_menu.dart';

main() {
  var app = new App();

  var mainMenu = new MainMenu();

  ButtonElement pauseButton = new ButtonElement()
      ..text = "Pause";

  DivElement buttonBarElement = new DivElement()
      ..className = "button-bar"
      ..append(pauseButton);

  document.body.children.add(buttonBarElement);

  var buttonBar = new ButtonBar(buttonBarElement, pauseButton);

  var glCanvas = new GLCanvas.attached();
  var gl = glCanvas.gl;
  var program = new GLProgram(gl);
  var boardRenderer = new BoardRenderer(program);

  var gameView = new GameView(buttonBar, glCanvas, gl, program, boardRenderer);

  var appView = new AppView(mainMenu, gameView);

  var appController = new AppController(app, appView);
  appController.run();
}
