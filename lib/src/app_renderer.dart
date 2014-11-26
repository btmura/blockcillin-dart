library app_renderer;

import 'dart:html';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/gl.dart';

class AppRenderer {

  final App app;

  AppRenderer(this.app);

  void render() {
    _resizeCanvas();
    _initGL();

    window.onResize.listen((event) {
      _resizeCanvas();
    });
  }

  void _resizeCanvas() {
    var bodyHeight = _getElementHeight("body");
    var buttonBarHeight = _getElementHeight("#button-bar");
    var canvasHeight = bodyHeight - buttonBarHeight - 1;

    var canvas = querySelector("#canvas");
    canvas.style.top = "${buttonBarHeight}px";
    canvas.style.height = "${canvasHeight}px";
  }

  int _getElementHeight(String selector) {
    return querySelector(selector).clientHeight;
  }

  void _initGL() {
    var gl = getWebGL("#canvas");
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
}
