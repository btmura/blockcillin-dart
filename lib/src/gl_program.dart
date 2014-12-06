part of client;

class GLProgram {

  final webgl.RenderingContext gl;
  final webgl.Program program;
  final webgl.UniformLocation projectionMatrixLocation;
  final webgl.UniformLocation viewMatrixLocation;
  final int positionLocation;

  factory GLProgram(webgl.RenderingContext gl) {
    var vertexShaderSource = '''
      uniform mat4 u_projectionMatrix;
      uniform mat4 u_viewMatrix;
      attribute vec4 a_position;

      void main(void) {
        gl_Position = u_projectionMatrix * u_viewMatrix * a_position;
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

    return new GLProgram._(gl, program, projectionMatrixLocation, viewMatrixLocation, positionLocation);
  }

  GLProgram._(this.gl, this.program, this.projectionMatrixLocation, this.viewMatrixLocation, this.positionLocation);
}