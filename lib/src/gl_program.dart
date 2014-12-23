part of client;

class GLProgram {

  final webgl.RenderingContext gl;
  final webgl.Program program;
  final webgl.UniformLocation projectionMatrixLocation;
  final webgl.UniformLocation viewMatrixLocation;
  final webgl.UniformLocation normalMatrixLocation;
  final webgl.UniformLocation boardRotationMatrixLocation;
  final int positionLocation;
  final int normalLocation;
  final int textureCoordLocation;

  factory GLProgram(webgl.RenderingContext gl) {
    var vertexShaderSource = '''
      uniform mat4 u_projectionMatrix;
      uniform mat4 u_viewMatrix;
      uniform mat4 u_normalMatrix;
      uniform mat4 u_boardRotationMatrix;

      attribute vec4 a_position;
      attribute vec3 a_normal;
      attribute vec2 a_textureCoord;

      varying vec2 v_textureCoord;
      varying vec3 v_lighting;

      void main(void) {
        gl_Position = u_projectionMatrix * u_viewMatrix * u_boardRotationMatrix * a_position;
        v_textureCoord = a_textureCoord;

        vec3 ambientLight = vec3(0.6, 0.6, 0.6);
        vec3 directionalLightColor = vec3(0.7, 0.7, 0.7);
        vec3 directionalVector = vec3(0.0, 1, 3);

        vec4 transformedNormal = u_normalMatrix * u_boardRotationMatrix * vec4(a_normal, 1.0);

        float directional = max(dot(transformedNormal.xyz, directionalVector), 0.0);
        v_lighting = ambientLight * (directionalLightColor * directional);
      }
    ''';

    var fragmentShaderSource = '''
      precision mediump float;

      varying vec2 v_textureCoord;
      varying vec3 v_lighting;
      
      uniform sampler2D u_texture;

      void main(void) {
        vec4 texelColor = texture2D(u_texture, v_textureCoord);
        gl_FragColor = vec4(texelColor.rgb * v_lighting, texelColor.a);
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

    var normalMatrixLocation = gl.getUniformLocation(program, "u_normalMatrix");
    if (normalMatrixLocation == null) {
      throw new StateError("u_normalMatrix not found");
    }

    var boardRotationMatrixLocation = gl.getUniformLocation(program, "u_boardRotationMatrix");
    if (boardRotationMatrixLocation == null) {
      throw new StateError("u_boardRotationMatrix not found");
    }

    var positionLocation = gl.getAttribLocation(program, "a_position");
    if (positionLocation == -1) {
      throw new StateError("a_position not found");
    }

    var normalLocation = gl.getAttribLocation(program, "a_normal");
    if (normalLocation == -1) {
      throw new StateError("a_normal not found");
    }

    var textureCoordLocation = gl.getAttribLocation(program, "a_textureCoord");
    if (textureCoordLocation == -1) {
      throw new StateError("a_textureCoord not found");
    }

    return new GLProgram._(gl, program, projectionMatrixLocation, viewMatrixLocation, normalMatrixLocation, boardRotationMatrixLocation, positionLocation, normalLocation, textureCoordLocation);
  }

  GLProgram._(this.gl, this.program, this.projectionMatrixLocation, this.viewMatrixLocation, this.normalMatrixLocation, this.boardRotationMatrixLocation, this.positionLocation, this.normalLocation, this.textureCoordLocation);
}