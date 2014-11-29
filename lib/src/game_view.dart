library game_view;

import 'dart:html';
import 'dart:typed_data';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/gl.dart';

class GameView {

  // TODO(btmura): add ButtonBar class

  final DivElement _buttonBar;
  final ButtonElement _pauseButton;
  final CanvasElement _canvas;

  webgl.RenderingContext _gl;
  int _positionAttrib;
  webgl.Buffer _vertexBuffer;
  webgl.Buffer _indexBuffer;

  GameView()
      : _buttonBar = new DivElement()
            ..className = "button-bar",
        _pauseButton = new ButtonElement()
            ..text = "Pause",
        _canvas = new CanvasElement()
            ..className = "canvas";

  set buttonBarVisible(bool visible) => _buttonBar.style.visibility = visible ? "visible" : "hidden";

  ElementStream<MouseEvent> get onPauseButtonClick => _pauseButton.onClick;

  bool setup() {
    _setupElements();
    resize();
    return _setupGL();
  }

  void _setupElements() {
    _buttonBar.children.add(_pauseButton);
    document.body.children
        ..add(_buttonBar)
        ..add(_canvas);
  }

  bool resize() {
    var changed = false;

    // Adjust the height of the canvas if it has changed.
    var wantedHeight = document.body.clientHeight - _buttonBar.clientHeight;
    if (_canvas.clientHeight != wantedHeight) {
      _canvas.style.height = "${wantedHeight}px";
      changed = true;
    }

    // Adjust the canvas dimensions to match it's displayed size to avoid scaling.
    if (_canvas.width != _canvas.clientWidth || _canvas.height != _canvas.clientHeight) {
      _canvas
          ..width = _canvas.clientWidth
          ..height = _canvas.clientHeight;
      changed = true;
    }

    return changed;
  }

  bool _setupGL() {
    _gl = getWebGL(_canvas);
    if (_gl == null) {
      return false;
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
      return false;
    }

    _positionAttrib = _gl.getAttribLocation(program, "a_position");
    if (_positionAttrib == null) {
      print("game_view: couldn't get a_position location");
      return false;
    }

    _gl.useProgram(program);

    var vertexData = [
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        1.0, 0.0, 0.0,
        0.0, -1.0, 0.0,
    ];
    _vertexBuffer = _gl.createBuffer();
    _gl
        ..bindBuffer(webgl.ARRAY_BUFFER, _vertexBuffer)
        ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(vertexData), webgl.STATIC_DRAW);

    var indexData = [
        0, 1, 2,
        0, 3, 2,
    ];
    _indexBuffer = _gl.createBuffer();
    _gl
        ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
        ..bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indexData), webgl.STATIC_DRAW);

    _gl.clearColor(0.0, 0.0, 0.0, 1.0);

    return true;
  }

  void draw() {
    _gl.clear(webgl.COLOR_BUFFER_BIT);

    _gl
        ..bindBuffer(webgl.ARRAY_BUFFER, _vertexBuffer)
        ..enableVertexAttribArray(_positionAttrib)
        ..vertexAttribPointer(_positionAttrib, 3, webgl.FLOAT, false, 0, 0);

    _gl
        ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
        ..drawElements(webgl.TRIANGLES, 6, webgl.UNSIGNED_SHORT, 0);
  }
}