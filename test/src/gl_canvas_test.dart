part of tests;

gl_canvas_tests() {
  var glCanvas;

  group("gl_canvas", () {
    setUp(() {
      var canvas = new CanvasElement();
      var gl = getWebGL(canvas);
      glCanvas = new GLCanvas(canvas, gl);
    });

    test("GLCanvas.gl", () {
      expect(glCanvas.gl, isNotNull);
    });

    test("GLCanvas.resize", () {
      expect(glCanvas.resize(300), isTrue);
      // TODO(btmura): use a mock to test this
      // expect(glCanvas.resize(300), isFalse);
    });
  });
}