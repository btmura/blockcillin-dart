part of test;

_gl_tests() {
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

  var canvas;
  var gl;

  group("gl", () {
    setUp(() {
      canvas = new CanvasElement();
      gl = getWebGL(canvas);
      expect(gl, isNotNull);
    });

    test("createProgram - valid shaders", () {
      var program = createProgram(gl, vertexShaderSource, fragmentShaderSource);
      expect(program, isNotNull);
    });

    test("createProgram - invalid vertex shader", () {
      var program = createProgram(gl, "bad vertex shader source", fragmentShaderSource);
      expect(program, isNull);
    });

    test("createProgram - invalid fragment shader", () {
      var program = createProgram(gl, vertexShaderSource, "bad fragment shader source");
      expect(program, isNull);
    });
  });
}
