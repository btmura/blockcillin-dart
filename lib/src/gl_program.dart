part of client;

class GLProgram {

  final webgl.RenderingContext gl;
  final webgl.Program program;
  final webgl.UniformLocation projectionMatrixLocation;
  final webgl.UniformLocation viewMatrixLocation;
  final webgl.UniformLocation normalMatrixLocation;
  final webgl.UniformLocation boardRotationMatrixLocation;
  final webgl.UniformLocation boardTranslationMatrixLocation;
  final webgl.UniformLocation grayscaleAmountLocation;
  final int positionLocation;
  final int positionOffsetLocation;
  final int normalLocation;
  final int textureCoordLocation;

  factory GLProgram(webgl.RenderingContext gl) {
    var vertexShaderSource = '''
      // TODO(btmura): use uniforms to make these configurable
      const vec3 ambientLight = vec3(0.7, 0.7, 0.7);
      const vec3 directionalLightColor = vec3(0.8, 0.8, 0.8);
      const vec3 directionalVector = vec3(0.0, 1.0, 3.0);

      uniform mat4 u_projectionMatrix;
      uniform mat4 u_viewMatrix;
      uniform mat4 u_normalMatrix;
      uniform mat4 u_boardRotationMatrix;
      uniform mat4 u_boardTranslationMatrix;

      attribute vec3 a_position;
      attribute vec3 a_positionOffset;
      attribute vec3 a_normal;
      attribute vec2 a_textureCoord;

      varying vec2 v_textureCoord;
      varying float v_blackAmount;
      varying vec3 v_lighting;

      void main(void) {
        vec4 position = u_boardRotationMatrix
            * u_boardTranslationMatrix
            * vec4(a_position + a_positionOffset, 1.0);

        gl_Position = u_projectionMatrix
            * u_viewMatrix
            * position;

        v_textureCoord = a_textureCoord;

        // TODO(btmura): use uniform to specify step thresholds
        v_blackAmount = 1.0 - smoothstep(-2.0, 0.0, position.y);

        vec4 transformedNormal = u_normalMatrix * vec4(a_normal, 1.0);
        float directional = max(dot(transformedNormal.xyz, directionalVector), 1.0);
        v_lighting = ambientLight * (directionalLightColor * directional);
      }
    ''';

    var fragmentShaderSource = '''
      precision mediump float;

      const vec3 blackColor = vec3(0.0, 0.0, 0.0);

      uniform sampler2D u_texture;
      uniform float u_grayscaleAmount;

      varying vec2 v_textureCoord;
      varying float v_blackAmount;
      varying vec3 v_lighting;
      
      void main(void) {
        vec4 color = texture2D(u_texture, v_textureCoord);
        vec3 grayscaleColor = vec3(color.r * 0.21 + color.g * 0.72 + color.b * 0.07);
        color = vec4(mix(color.rgb, grayscaleColor, u_grayscaleAmount), color.a);
        color = vec4(mix(color.rgb, blackColor, v_blackAmount), color.a); 
        color = vec4(color.rgb * v_lighting, color.a);
        gl_FragColor = color;
      }
    ''';

    var program = createProgram(gl, vertexShaderSource, fragmentShaderSource);
    if (program == null) {
      throw new StateError("couldn't create program");
    }

    webgl.UniformLocation mustGetUniformLocation(String name) {
      var location = gl.getUniformLocation(program, name);
      if (location == null) {
        throw new StateError("${name} not found");
      }
      return location;
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

    var boardTranslationMatrixLocation = gl.getUniformLocation(program, "u_boardTranslationMatrix");
    if (boardTranslationMatrixLocation == null) {
      throw new StateError("u_boardTranslationMatrix not found");
    }

    var grayscaleAmountLocation = mustGetUniformLocation("u_grayscaleAmount");

    var positionLocation = gl.getAttribLocation(program, "a_position");
    if (positionLocation == -1) {
      throw new StateError("a_position not found");
    }

    var positionOffsetLocation = gl.getAttribLocation(program, "a_positionOffset");
    if (positionOffsetLocation == -1) {
      throw new StateError("a_positionOffset not found");
    }

    var normalLocation = gl.getAttribLocation(program, "a_normal");
    if (normalLocation == -1) {
      throw new StateError("a_normal not found");
    }

    var textureCoordLocation = gl.getAttribLocation(program, "a_textureCoord");
    if (textureCoordLocation == -1) {
      throw new StateError("a_textureCoord not found");
    }

    return new GLProgram._(
        gl,
        program,
        projectionMatrixLocation,
        viewMatrixLocation,
        normalMatrixLocation,
        boardRotationMatrixLocation,
        boardTranslationMatrixLocation,
        grayscaleAmountLocation,
        positionLocation,
        positionOffsetLocation,
        normalLocation,
        textureCoordLocation);
  }

  GLProgram._(
      this.gl,
      this.program,
      this.projectionMatrixLocation,
      this.viewMatrixLocation,
      this.normalMatrixLocation,
      this.boardRotationMatrixLocation,
      this.boardTranslationMatrixLocation,
      this.grayscaleAmountLocation,
      this.positionLocation,
      this.positionOffsetLocation,
      this.normalLocation,
      this.textureCoordLocation);
}