part of client;

class GLProgram {

  final webgl.RenderingContext gl;
  final webgl.Program program;
  final webgl.UniformLocation projectionMatrixLocation;
  final webgl.UniformLocation viewMatrixLocation;
  final int positionLocation;
  final int textureCoordLocation;

  factory GLProgram(webgl.RenderingContext gl) {
    var vertexShaderSource = '''
      uniform mat4 u_projectionMatrix;
      uniform mat4 u_viewMatrix;
      attribute vec4 a_position;
      attribute vec2 a_textureCoord;

      varying vec2 v_textureCoord;

      void main(void) {
        gl_Position = u_projectionMatrix * u_viewMatrix * a_position;
        v_textureCoord = a_textureCoord;
      }
    ''';

    var fragmentShaderSource = '''
      precision mediump float;

      varying vec2 v_textureCoord;      
      uniform sampler2D u_texture;

      void main(void) {
        gl_FragColor = texture2D(u_texture, v_textureCoord);
      }
    ''';

    var program = createProgram(gl, vertexShaderSource, fragmentShaderSource);
    if (program == null) {
      throw new StateError("couldn't create program");
    }

    var projectionMatrixLocation = gl.getUniformLocation(program, "u_projectionMatrix");
    if (projectionMatrixLocation == null) {
      throw new StateError("u_projectionMatrix not found");
    }

    var viewMatrixLocation = gl.getUniformLocation(program, "u_viewMatrix");
    if (viewMatrixLocation == null) {
      throw new StateError("u_viewMatrix not found");
    }

    var positionLocation = gl.getAttribLocation(program, "a_position");
    if (positionLocation == null) {
      throw new StateError("a_position not found");
    }

    var textureCoordLocation = gl.getAttribLocation(program, "a_textureCoord");
    if (textureCoordLocation == null) {
      throw new StateError("a_textureCoord not found");
    }

    return new GLProgram._(gl, program, projectionMatrixLocation, viewMatrixLocation, positionLocation, textureCoordLocation);
  }

  GLProgram._(this.gl, this.program, this.projectionMatrixLocation, this.viewMatrixLocation, this.positionLocation, this.textureCoordLocation);
}