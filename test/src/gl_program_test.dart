part of tests;

gl_program_tests() {

  var glCanvas;
  var glProgram;

  group("gl_program", () {
    setUp(() {
      glCanvas = new GLCanvas();
      glCanvas.add();
      glCanvas.init();
      glProgram = new GLProgram(glCanvas.gl);
    });

    test("GLProgram.gl", () {
      expect(glProgram.gl, isNotNull);
    });

    test("GLProgram.program", () {
      expect(glProgram.program, isNotNull);
    });

    test("GLProgram.positionAttrib", () {
      expect(glProgram.positionAttrib, isNonZero);
    });

    tearDown(() {
      glCanvas.remove();
    });
  });
}