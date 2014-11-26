import 'dart:html';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/game.dart';
import 'package:blockcillin/src/gl.dart';

main() {
  var game = new Game.withRandomBoard(3, 3);

  var canvas = querySelector("#canvas");
  var gl = getWebGL(canvas);
  if (gl == null) {
    return;
  }

  var vertexShaderSource = '''
    void main(void) {
      gl_Position = vec4(0.0, 0.0, 0.0, 0.0);    
    }
  ''';

  var fragmentShaderSource = '''
    precision mediump float;

    void main(void) {
      gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
  ''';

  var program = createProgram(gl, vertexShaderSource, fragmentShaderSource);
  if (program == null) {
    return;
  }
  gl.useProgram(program);

  gl.clearColor(0.0, 0.0, 0.0, 1.0);
  gl.clear(webgl.COLOR_BUFFER_BIT);
}


