part of tests;

gl_tests() {
  const vertexShaderSource = '''
    void main(void) {
      gl_Position = vec4(0.0, 0.0, 0.0, 0.0);    
    }
  ''';

  const fragmentShaderSource = '''
    precision mediump float;
  
    void main(void) {
      gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
  ''';

  var gl;

  group("gl", () {
    setUp(() {
      gl = getWebGL("#canvas");
      expect(gl, isNotNull);
    });

    test("createProgram(gl, vertexShaderSource, fragmentShaderSource) - valid shaders", () {
      var program = createProgram(gl, vertexShaderSource, fragmentShaderSource);
      expect(program, isNotNull);
    });

    test("createProgram(gl, vertexShaderSource, fragmentShaderSource) - invalid vertex shader", () {
      var program = createProgram(gl, "bad vertex shader source", fragmentShaderSource);
      expect(program, isNull);
    });

    test("createProgram(gl, vertexShaderSource, fragmentShaderSource) - invalid fragment shader", () {
      var program = createProgram(gl, vertexShaderSource, "bad fragment shader source");
      expect(program, isNull);
    });
  });
}
