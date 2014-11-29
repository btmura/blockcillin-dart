library game_view;

import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/gl.dart';

class GameView {

  final DivElement _buttonBar;
  final CanvasElement _canvas;

  webgl.RenderingContext _gl;
  int _positionAttrib;
  webgl.Buffer _vertexBuffer;
  webgl.Buffer _indexBuffer;

  GameView()
      : _buttonBar = new DivElement()
            ..id = "button-bar"
            ..text = "Buttons",
        _canvas = new CanvasElement()
            ..id = "canvas";

  void setup() {
    _addElements();
    resize();
    _initGL();
  }

  void _addElements() {
    document.body.children.add(_buttonBar);
    document.body.children.add(_canvas);
  }

  void resize() {
    // Adjust the height of the canvas if it has changed.
    var wantedHeight = document.body.clientHeight - _buttonBar.clientHeight;
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
    _gl = getWebGL(_canvas);
    if (_gl == null) {
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

    var program = createProgram(_gl, vertexShaderSource, fragmentShaderSource);
    if (program == null) {
      return;
    }
    _gl.useProgram(program);

    _positionAttrib = _gl.getAttribLocation(program, "a_position");
    if (_positionAttrib == null) {
      print("positionAttrib is null");
      return;
    }

    _gl.clearColor(0.0, 0.0, 0.0, 1.0);

    var vertexData = [
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        1.0, 0.0, 0.0,
        0.0, -1.0, 0.0,
    ];
    _vertexBuffer = _gl.createBuffer();
    _gl.bindBuffer(webgl.ARRAY_BUFFER, _vertexBuffer);
    _gl.bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(vertexData), webgl.STATIC_DRAW);

    var indexData = [
        0, 1, 2,
        0, 3, 2,
    ];
    _indexBuffer = _gl.createBuffer();
    _gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer);
    _gl.bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indexData), webgl.STATIC_DRAW);
  }

  void draw() {
    _gl.clear(webgl.COLOR_BUFFER_BIT);

    _gl.bindBuffer(webgl.ARRAY_BUFFER, _vertexBuffer);
    _gl.enableVertexAttribArray(_positionAttrib);
    _gl.vertexAttribPointer(_positionAttrib, 3, webgl.FLOAT, false, 0, 0);

    _gl.bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer);
    _gl.drawElements(webgl.TRIANGLES, 6, webgl.UNSIGNED_SHORT, 0);
  }
}