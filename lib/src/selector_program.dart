part of blockcillin;

/// GLSL program for the selector.
class SelectorProgram {

  final webgl.Program program;

  final webgl.UniformLocation projectionViewMatrixUniform;
  final int positionAttrib;
  final int textureCoordAttrib;

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
        program,
        uniform("u_projectionViewMatrix"),
        attribute("a_position"),
        attribute("a_textureCoord"));
  }

  SelectorProgram._(
      this.program,
      this.projectionViewMatrixUniform,
      this.positionAttrib,
      this.textureCoordAttrib);
}