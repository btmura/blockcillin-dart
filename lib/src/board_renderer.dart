library board_renderer;

import 'dart:typed_data';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/board.dart';
import 'package:blockcillin/src/gl_program.dart';

class BoardRenderer {

  final webgl.RenderingContext _gl;
  final webgl.Program _program;
  final int _positionAttrib;

  final webgl.Buffer _vertexBuffer;
  final webgl.Buffer _indexBuffer;

  factory BoardRenderer(GLProgram glProgram) {
    var gl = glProgram.gl;
    var program = glProgram.program;

    var vertexData = [
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        1.0, 0.0, 0.0,
        0.0, -1.0, 0.0,
    ];
    var vertexBuffer = gl.createBuffer();
    gl
        ..bindBuffer(webgl.ARRAY_BUFFER, vertexBuffer)
        ..bufferData(webgl.ARRAY_BUFFER, new Float32List.fromList(vertexData), webgl.STATIC_DRAW);

    var indexData = [
        0, 1, 2,
        0, 3, 2,
    ];
    var indexBuffer = gl.createBuffer();
    gl
        ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, indexBuffer)
        ..bufferData(webgl.ELEMENT_ARRAY_BUFFER, new Uint16List.fromList(indexData), webgl.STATIC_DRAW);

    return new BoardRenderer._(gl, program, glProgram.positionLocation, vertexBuffer, indexBuffer);
  }

  BoardRenderer._(this._gl, this._program, this._positionAttrib, this._vertexBuffer, this._indexBuffer);

  void render(Board board) {
    _gl
        ..bindBuffer(webgl.ARRAY_BUFFER, _vertexBuffer)
        ..enableVertexAttribArray(_positionAttrib)
        ..vertexAttribPointer(_positionAttrib, 3, webgl.FLOAT, false, 0, 0);

    _gl
        ..bindBuffer(webgl.ELEMENT_ARRAY_BUFFER, _indexBuffer)
        ..drawElements(webgl.TRIANGLES, 6, webgl.UNSIGNED_SHORT, 0);
  }
}