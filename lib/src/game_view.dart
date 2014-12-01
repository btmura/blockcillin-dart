library game_view;

import 'dart:html';
import 'dart:math' as math;
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/board_renderer.dart';
import 'package:blockcillin/src/button_bar.dart';
import 'package:blockcillin/src/game.dart';
import 'package:blockcillin/src/gl_canvas.dart';
import 'package:blockcillin/src/gl_program.dart';

class GameView {

  final ButtonBar buttonBar;
  final GLCanvas glCanvas;

  final webgl.RenderingContext _gl;
  final BoardRenderer _boardRenderer;

  GameView(this.buttonBar, this.glCanvas, this._gl, this._boardRenderer);

  factory GameView.append() {
    var buttonBar = new ButtonBar.append();
    var glCanvas = new GLCanvas.append();

    var gl = glCanvas.gl;
    gl.clearColor(0.0, 0.0, 0.0, 1.0);

    var program = new GLProgram(gl);
    var boardRenderer = new BoardRenderer(program);

    return new GameView(buttonBar, glCanvas, gl, boardRenderer);
  }

  void remove() {
    buttonBar.remove();
    glCanvas.remove();
  }

  List<double> _makeProjectionMatrix() {
    var aspect = glCanvas.width / glCanvas.height;
    var fovRadians = math.PI / 2;
    return _makePerspectiveMatrix(fovRadians, aspect, 1.0, 2000.0);
  }

  List<double> _makePerspectiveMatrix(double fovRadians, double aspect, double near, double far) {
    var f = math.tan(math.PI * 0.5 - 0.5 * fovRadians);
    var rangeInv = 1.0 / (near - far);
    return [
        f / aspect, 0, 0, 0,
        0, f, 0, 0,
        0, 0, (near + far) * rangeInv, -1,
        0, 0, near * far * rangeInv * 2, 0
    ];
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