library game_view;

import 'dart:html';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/board_renderer.dart';
import 'package:blockcillin/src/button_bar.dart';
import 'package:blockcillin/src/game.dart';
import 'package:blockcillin/src/gl_canvas.dart';

class GameView {

  final ButtonBar buttonBar = new ButtonBar();
  final GLCanvas glCanvas = new GLCanvas();

  webgl.RenderingContext _gl;
  BoardRenderer _boardRenderer;

  bool init() {
    buttonBar.add();
    glCanvas.add();
    resize();

    if (!glCanvas.init()) {
      return false;
    }

    _gl = glCanvas.gl;
    _gl.clearColor(0.0, 0.0, 0.0, 1.0);

    _boardRenderer = new BoardRenderer(_gl);
    if (!_boardRenderer.init()) {
      return false;
    }

    return true;
  }

  bool resize() {
    var height = document.body.clientHeight - buttonBar.height;
    return glCanvas.resize(height);
  }

  void draw(Game game) {
    _gl.clear(webgl.COLOR_BUFFER_BIT);
    _boardRenderer.render(game.board);
  }
}