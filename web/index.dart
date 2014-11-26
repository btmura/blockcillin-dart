import 'dart:html';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/game.dart';

main() {
  var game = new Game.withRandomBoard(3, 3);

  var canvas = querySelector("#canvas");
  var gl = getWebGL(canvas);
  if (gl == null) {
    return;
  }

  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.clear(webgl.COLOR_BUFFER_BIT);
}

webgl.RenderingContext getWebGL(CanvasElement canvas) {
  var gl = canvas.getContext("webgl");
  if (gl != null) {
    return gl;
  }

  gl = canvas.getContext("experimental-webgl");
  if (gl != null) {
    return gl;
  }

  return null;
}

