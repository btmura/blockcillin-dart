part of tests;

gl_canvas_tests() {
  var glCanvas;

  group("gl_canvas", () {
    setUp(() {
      var canvas = new CanvasElement();
      glCanvas = new GLCanvas(canvas);
    });

    test("GLCanvas.resize", () {
      expect(glCanvas.resize(300), isTrue);
      // TODO(btmura): use a mock to test this
      // expect(glCanvas.resize(300), isFalse);
    });
  });
}