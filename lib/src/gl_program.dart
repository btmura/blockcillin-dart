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
  final webgl.UniformLocation blackAmountLocation;
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
      uniform float u_blackAmount;

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
        v_blackAmount = max(1.0 - smoothstep(-2.0, 0.0, position.y), u_blackAmount);

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

    webgl.UniformLocation uniform(String name) {
      var location = gl.getUniformLocation(program, name);
      if (location == null) {
        throw new StateError("${name} not found");
      }
      return location;
    }

    int attrib(String name) {
      var location = gl.getAttribLocation(program, name);
      if (location == -1) {
        throw new StateError("${name} not found");
      }
      return location;
    }

    return new GLProgram._(
        gl,
        program,
        uniform("u_projectionMatrix"),
        uniform("u_viewMatrix"),
        uniform("u_normalMatrix"),
        uniform("u_boardRotationMatrix"),
        uniform("u_boardTranslationMatrix"),
        uniform("u_grayscaleAmount"),
        uniform("u_blackAmount"),
        attrib("a_position"),
        attrib("a_positionOffset"),
        attrib("a_normal"),
        attrib("a_textureCoord"));
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
      this.blackAmountLocation,
      this.positionLocation,
      this.positionOffsetLocation,
      this.normalLocation,
      this.textureCoordLocation);
}