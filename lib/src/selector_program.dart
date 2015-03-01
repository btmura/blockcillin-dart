part of blockcillin;

/// GLSL program for the selector.
class SelectorProgram {

  final webgl.RenderingContext _gl;
  final webgl.Program _program;
  final webgl.UniformLocation _projectionViewMatrixUniform;
  final int _positionAttrib;
  final int _textureCoordAttrib;

  factory SelectorProgram(webgl.RenderingContext gl) {
    var vertexShader = '''
      uniform mat4 u_projectionViewMatrix;

      attribute vec4 a_position;
      attribute vec2 a_textureCoord;

      varying vec2 v_textureCoord;

      void main(void) {
        gl_Position = u_projectionViewMatrix * a_position;
        v_textureCoord = a_textureCoord;
      }
    ''';

    var fragmentShader = '''
      precision mediump float;

      uniform sampler2D u_texture;

      varying vec2 v_textureCoord;

      void main(void) {
        gl_FragColor = texture2D(u_texture, v_textureCoord);
      }
    ''';

    var program = createProgram(gl, vertexShader, fragmentShader);
    var uniform = newUniformLocator(gl, program);
    var attribute = newAttribLocator(gl, program);

    return new SelectorProgram._(
        gl,
        program,
        uniform("u_projectionViewMatrix"),
        attribute("a_position"),
        attribute("a_textureCoord"));
  }

  SelectorProgram._(
      this._gl,
      this._program,
      this._projectionViewMatrixUniform,
      this._positionAttrib,
      this._textureCoordAttrib);

  void useProgram() {
    _gl.useProgram(_program);
  }

  void setProjectionViewMatrix(Matrix4 matrix) {
    _gl.uniformMatrix4fv(_projectionViewMatrixUniform, false, matrix.floatList);
  }

  void enableArrays(webgl.Buffer positionBuffer, webgl.Buffer textureCoordBuffer) {
    enableVertexAttribArray3f(_gl, positionBuffer, _positionAttrib);
    enableVertexAttribArray2f(_gl, textureCoordBuffer, _textureCoordAttrib);
  }

  void disableArrays() {
    disableVertexAttribArray(_gl, _positionAttrib);
    disableVertexAttribArray(_gl, _textureCoordAttrib);
  }
}