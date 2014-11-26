library app_renderer;

import 'dart:html';
import 'dart:typed_data';
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
    // Adjust the height of the canvas if it has changed.
    var wantedHeight = _body.clientHeight - _buttonBar.clientHeight - 5;
    if (_canvas.clientHeight != wantedHeight) {
      _canvas.style.height = "${wantedHeight}px";
    }

    // Adjust the canvas dimensions to match it's displayed size to avoid scaling.
    if (_canvas.width != _canvas.clientWidth || _canvas.height != _canvas.clientHeight) {
      _canvas.width = _canvas.clientWidth;
      _canvas.height = _canvas.clientHeight;
    }
  }

  void _initGL() {
    var gl = getWebGL("#canvas");
    if (gl == null) {
      return;
    }

    var vertexShaderSource = '''
      attribute vec4 a_position;

      void main(void) {
        gl_Position = a_position;    
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

    var positionAttrib = gl.getAttribLocation(program, "a_position");
    if (positionAttrib == null) {
      print("positionAttrib is null");
      return;
    }

    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(webgl.COLOR_BUFFER_BIT);

    var vertexData = [
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        1.0, 0.0, 0.0,
    ];
    webgl.Buffer vertexBuffer = gl.createBuffer();
    gl.bindBuffer(webgl.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(vertexData), webgl.STATIC_DRAW);

    gl.enableVertexAttribArray(positionAttrib);
    gl.vertexAttribPointer(positionAttrib, 3, webgl.FLOAT, false, 0, 0);

    var indexData = [
        0, 1, 2,
    ];
    webgl.Buffer indexBuffer = gl.createBuffer();
    gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indexData), webgl.STATIC_DRAW);

    gl.drawElements(webgl.TRIANGLES, 3, webgl.UNSIGNED_SHORT, 0);
  }
}
