part of blockcillin;

/// GLSL program for the board.
class BoardProgram {

  final webgl.Program program;

  final webgl.UniformLocation boardRotationMatrixUniform;
  final webgl.UniformLocation boardTranslationMatrixUniform;
  final webgl.UniformLocation grayscaleAmountUniform;
  final webgl.UniformLocation blackAmountUniform;

  final int positionAttrib;
  final int positionOffsetAttrib;
  final int normalAttrib;
  final int textureCoordAttrib;

  final webgl.RenderingContext _gl;
  final webgl.UniformLocation _projectionViewMatrixUniform;
  final webgl.UniformLocation _normalMatrixUniform;

  factory BoardProgram(webgl.RenderingContext gl) {
    var vertexShader = '''
      // TODO(btmura): use uniforms to make these configurable
      const vec3 ambientLight = vec3(0.7, 0.7, 0.7);
      const vec3 directionalLightColor = vec3(0.4, 0.4, 0.4);
      const vec3 directionalVector = vec3(0.0, 3.0, -3.0);

      uniform mat4 u_projectionViewMatrix;
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

        gl_Position = u_projectionViewMatrix * position;

        v_textureCoord = a_textureCoord;

        // TODO(btmura): use uniform to specify step thresholds
        v_blackAmount = max(1.0 - smoothstep(-2.0, 0.0, position.y), u_blackAmount);

        vec4 transformedNormal = u_normalMatrix * vec4(a_normal, 1.0);
        float directional = max(dot(transformedNormal.xyz, directionalVector), 0.0);
        v_lighting = ambientLight * (directionalLightColor * directional);
      }
    ''';

    var fragmentShader = '''
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

    var program = createProgram(gl, vertexShader, fragmentShader);
    var uniform = newUniformLocator(gl, program);
    var attrib = newAttribLocator(gl, program);

    return new BoardProgram._(
        gl,
        program,
        uniform("u_projectionViewMatrix"),
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

  BoardProgram._(
      this._gl,
      this.program,
      this._projectionViewMatrixUniform,
      this._normalMatrixUniform,
      this.boardRotationMatrixUniform,
      this.boardTranslationMatrixUniform,
      this.grayscaleAmountUniform,
      this.blackAmountUniform,
      this.positionAttrib,
      this.positionOffsetAttrib,
      this.normalAttrib,
      this.textureCoordAttrib);

  void setProjectionViewMatrix(Matrix4 matrix) {
    _gl
      ..useProgram(program)
      ..uniformMatrix4fv(_projectionViewMatrixUniform, false, matrix.floatList);
  }

  void setNormalMatrix(Matrix4 matrix) {
    _gl
      ..useProgram(program)
      ..uniformMatrix4fv(_normalMatrixUniform, false, matrix.floatList);
  }
}