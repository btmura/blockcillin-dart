library board_renderer;

import 'dart:typed_data';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/board.dart';
import 'package:blockcillin/src/gl.dart';

class BoardRenderer {

  final webgl.RenderingContext _gl;

  webgl.Program _program;
  int _positionAttrib;
  webgl.Buffer _vertexBuffer;
  webgl.Buffer _indexBuffer;

  BoardRenderer(this._gl);

  bool init() {
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

    _program = createProgram(_gl, vertexShaderSource, fragmentShaderSource);
    if (_program == null) {
      return false;
    }

    _positionAttrib = _gl.getAttribLocation(_program, "a_position");
    if (_positionAttrib == null) {
      print("board_renderer: couldn't get a_position location");
      return false;
    }

    _gl.useProgram(_program);

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

    return true;
  }

  void render(Board board) {
    _gl.useProgram(_program);

    _gl
        ..bindBuffer(webgl.ARRAY_BUFFER, _vertexBuffer)
        ..enableVertexAttribArray(_positionAttrib)
        ..vertexAttribPointer(_positionAttrib, 3, webgl.FLOAT, false, 0, 0);

    _gl
        ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
        ..drawElements(webgl.TRIANGLES, 6, webgl.UNSIGNED_SHORT, 0);
  }
}