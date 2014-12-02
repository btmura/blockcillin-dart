library game_view;

import 'dart:html';
import 'dart:typed_data';
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
  final GLProgram _program;
  final BoardRenderer _boardRenderer;

  Float32List _projectionMatrix;

  GameView(this.buttonBar, this.glCanvas, this._gl, this._program, this._boardRenderer) {
    _gl.clearColor(0.0, 0.0, 0.0, 1.0);
    _projectionMatrix = _makeProjectionMatrix();
  }

  bool resize() {
    var height = document.body.clientHeight - buttonBar.height;
    var resized = glCanvas.resize(height);
    if (resized) {
      _projectionMatrix = _makeProjectionMatrix();
    }
    return resized;
  }

  void draw(Game game) {
    _gl.clear(webgl.COLOR_BUFFER_BIT | webgl.DEPTH_BUFFER_BIT);
    _gl.viewport(0, 0, glCanvas.width, glCanvas.height);

    _gl.useProgram(_program.program);
    _gl.uniformMatrix4fv(_program.projectionMatrixLocation, false, _projectionMatrix);

    _boardRenderer.render(game.board);
  }

  Float32List _makeProjectionMatrix() {
    var aspect = glCanvas.width / glCanvas.height;
    var fovRadians = math.PI / 2;
    return _makePerspectiveMatrix(fovRadians, aspect, 1.0, 2000.0);
  }

  Float32List _makePerspectiveMatrix(double fovRadians, double aspect, double near, double far) {
    var f = math.tan(math.PI * 0.5 - 0.5 * fovRadians);
    var rangeInv = 1.0 / (near - far);
    return new Float32List.fromList([
        f / aspect, 0.0, 0.0, 0.0,
        0.0, f, 0.0, 0.0,
        0.0, 0.0, (near + far) * rangeInv, -1.0,
        0.0, 0.0, near * far * rangeInv * 2.0, 0.0
    ]);
  }
}