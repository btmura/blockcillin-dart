library client;

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
part 'src/board_renderer.dart';
part 'src/button_bar.dart';
part 'src/cell.dart';
part 'src/fader.dart';
part 'src/game.dart';
part 'src/game_view.dart';
part 'src/gl.dart';
part 'src/gl_program.dart';
part 'src/main_menu.dart';
part 'src/math.dart';
part 'src/matrix4.dart';
part 'src/quaternion.dart';
part 'src/ring.dart';
part 'src/state.dart';
part 'src/vector2.dart';
part 'src/vector3.dart';

void run_client() {
  // Create the button bar for pausing the game and add it first to put it at the top.
  var buttonBar = new ButtonBar.withElements();
  document.body.children.add(buttonBar.element);

  // Create the canvas. Add canvas after button bar to maximize it below the bar.
  var canvas = new CanvasElement()
      ..className = "canvas";
  document.body.children.add(canvas);

  // Initialize the canvas now that we're done setting up the DOM.
  var gl = getWebGL(canvas);
  if (gl == null) {
    // TODO(btmura): handle when WebGL isn't supported
    return;
  }

  // Wait for the texture to load before showing the main menu.
  var image = new ImageElement(src: "packages/blockcillin/texture.png");
  image.onLoad.listen((_) {
    var glProgram = new GLProgram(gl);
    var boardRenderer = new BoardRenderer(glProgram, image);
    var gameView = new GameView(buttonBar, canvas, glProgram, boardRenderer);
    var mainMenu = new MainMenu.withElements();

    var app = new App();
    var stopwatch = new Stopwatch();
    var appController = new AppController(app, mainMenu, gameView, stopwatch);

    appController.run();
  });
}