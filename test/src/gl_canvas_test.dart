part of tests;

gl_canvas_tests() {
  var glCanvas;

  group("gl_canvas", () {
    setUp(() {
      glCanvas = new GLCanvas();
      glCanvas.add();
    });

    test("GLCanvas.gl", () {
      expect(glCanvas.gl, isNull);
      expect(glCanvas.init(), isTrue);
      expect(glCanvas.gl, isNotNull);
    });

    test("GLCanvas.resize", () {
      expect(glCanvas.resize(300), isTrue);
      expect(glCanvas.resize(300), isFalse);
    });

    tearDown(() {
      glCanvas.remove();
    });
  });
}