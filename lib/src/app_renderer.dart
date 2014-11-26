library app_renderer;

import 'dart:html';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/app.dart';
import 'package:blockcillin/src/gl.dart';

class AppRenderer {

  final App app;

  BodyElement _body;
  DivElement _buttonBar;
  CanvasElement _canvas;

  AppRenderer(this.app) {
    _body = querySelector("body");
    _buttonBar = querySelector("#button-bar");
    _canvas = querySelector("#canvas");
  }

  void render() {
    _resizeCanvas();
    _initGL();

    window.onResize.listen((event) {
      _resizeCanvas();
    });
  }

  void _resizeCanvas() {
    var wantedTop = _buttonBar.clientHeight;
    if (_canvas.clientTop != wantedTop) {
      _canvas.style.top = "${wantedTop}px";
    }

    var wantedHeight = _body.clientHeight - _buttonBar.clientHeight - 1;
    if (_canvas.clientHeight != wantedHeight) {
      _canvas.style.height = "${wantedHeight}px";
    }
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
