library gl_program;

import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/gl.dart';

class GLProgram {

  final webgl.RenderingContext gl;
  final webgl.Program program;
  final webgl.UniformLocation projectionMatrixLocation;
  final int positionAttrib;

  factory GLProgram(webgl.RenderingContext gl) {
    var vertexShaderSource = '''
      uniform mat4 u_projectionMatrix;
      attribute vec4 a_position;

      void main(void) {
        gl_Position = u_projectionMatrix * a_position;
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
      throw new ArgumentError("couldn't create program");
    }

    var projectionMatrixUniform = gl.getUniformLocation(program, "u_projectionMatrix");
    if (projectionMatrixUniform == null) {
      throw new ArgumentError("u_projectionMatrix not found");
    }

    var positionAttrib = gl.getAttribLocation(program, "a_position");
    if (positionAttrib == null) {
      throw new ArgumentError("a_position not found");
    }

    return new GLProgram._(gl, program, projectionMatrixUniform, positionAttrib);
  }

  GLProgram._(this.gl, this.program, this.projectionMatrixLocation, this.positionAttrib);
}