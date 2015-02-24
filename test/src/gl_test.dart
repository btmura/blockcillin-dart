part of test;

_gl_tests() {
  group("gl", () {
    const vertexShader = '''
      void main(void) {
        gl_Position = vec4(0.0, 0.0, 0.0, 0.0);    
      }
    ''';

    const fragmentShader = '''
      precision mediump float;
    
      void main(void) {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    ''';

    webgl.RenderingContext gl;

    setUp(() {
      var canvas = new CanvasElement();
      gl = getWebGL(canvas);
      expect(gl, isNotNull);
    });

    test("createProgram - valid shaders", () {
      var program = createProgram(gl, vertexShader, fragmentShader);
      expect(program, isNotNull);
    });

    test("createProgram - invalid vertex shader", () {
      try {
        createProgram(gl, "bad vertex shader source", fragmentShader);
        fail("should have thrown exception");
      } on ArgumentError {}
    });

    test("createProgram - invalid fragment shader", () {
      try {
        createProgram(gl, vertexShader, "bad fragment shader source");
        fail("should have thrown exception");
      } on ArgumentError {}
    });
  });
}
