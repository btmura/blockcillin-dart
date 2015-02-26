part of blockcillin;

/// GLSL program for the board.
class BoardProgram {

  final int positionAttrib;
  final int positionOffsetAttrib;
  final int normalAttrib;
  final int textureCoordAttrib;

  final webgl.RenderingContext _gl;
  final webgl.Program _program;
  final webgl.UniformLocation _projectionViewMatrixUniform;
  final webgl.UniformLocation _boardMatrixUniform;
  final webgl.UniformLocation _normalMatrixUniform;
  final webgl.UniformLocation _grayscaleUniform;
  final webgl.UniformLocation _blackUniform;

  factory BoardProgram(webgl.RenderingContext gl) {
    var vertexShader = '''
      // TODO(btmura): use uniforms to make these configurable
      const vec3 ambientLight = vec3(0.7, 0.7, 0.7);
      const vec3 directionalLightColor = vec3(0.4, 0.4, 0.4);
      const vec3 directionalVector = vec3(0.0, 3.0, -3.0);

      uniform mat4 u_projectionViewMatrix;
      uniform mat4 u_boardMatrix;
      uniform mat4 u_normalMatrix;
      uniform float u_black;

      attribute vec3 a_position;
      attribute vec3 a_positionOffset;
      attribute vec3 a_normal;
      attribute vec2 a_textureCoord;

      varying vec2 v_textureCoord;
      varying float v_black;
      varying vec3 v_lighting;

      void main(void) {
        vec4 position = u_boardMatrix * vec4(a_position + a_positionOffset, 1.0);

        gl_Position = u_projectionViewMatrix * position;

        v_textureCoord = a_textureCoord;

        // TODO(btmura): use uniform to specify step thresholds
        v_black = max(1.0 - smoothstep(-2.0, 0.0, position.y), u_black);

        vec4 transformedNormal = u_normalMatrix * vec4(a_normal, 1.0);
        float directional = max(dot(transformedNormal.xyz, directionalVector), 0.0);
        v_lighting = ambientLight * (directionalLightColor * directional);
      }
    ''';

    var fragmentShader = '''
      precision mediump float;

      const vec3 blackColor = vec3(0.0, 0.0, 0.0);

      uniform sampler2D u_texture;
      uniform float u_grayscale;

      varying vec2 v_textureCoord;
      varying float v_black;
      varying vec3 v_lighting;
      
      void main(void) {
        vec4 color = texture2D(u_texture, v_textureCoord);
        vec3 grayscaleColor = vec3(color.r * 0.21 + color.g * 0.72 + color.b * 0.07);
        color = vec4(mix(color.rgb, grayscaleColor, u_grayscale), color.a);
        color = vec4(mix(color.rgb, blackColor, v_black), color.a);
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
        uniform("u_boardMatrix"),
        uniform("u_normalMatrix"),
        uniform("u_grayscale"),
        uniform("u_black"),
        attrib("a_position"),
        attrib("a_positionOffset"),
        attrib("a_normal"),
        attrib("a_textureCoord"));
  }

  BoardProgram._(
      this._gl,
      this._program,
      this._projectionViewMatrixUniform,
      this._boardMatrixUniform,
      this._normalMatrixUniform,
      this._grayscaleUniform,
      this._blackUniform,
      this.positionAttrib,
      this.positionOffsetAttrib,
      this.normalAttrib,
      this.textureCoordAttrib);

  void useProgram() {
    _gl.useProgram(_program);
  }

  void setProjectionViewMatrix(Matrix4 matrix) {
    _gl.uniformMatrix4fv(_projectionViewMatrixUniform, false, matrix.floatList);
  }

  void setBoardMatrix(Matrix4 matrix) {
    _gl.uniformMatrix4fv(_boardMatrixUniform, false, matrix.floatList);
  }

  void setNormalMatrix(Matrix4 matrix) {
    _gl.uniformMatrix4fv(_normalMatrixUniform, false, matrix.floatList);
  }

  void setGrayscale(double amount) {
    _gl.uniform1f(_grayscaleUniform, amount);
  }

  void setBlack(double amount) {
    _gl.uniform1f(_blackUniform, amount);
  }
}