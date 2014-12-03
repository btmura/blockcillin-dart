part of tests;

gl_program_tests() {

  var glCanvas;
  var glProgram;

  group("gl_program", () {
    setUp(() {
      glCanvas = new GLCanvas.attached();
      glProgram = new GLProgram(glCanvas.gl);
    });

    test("GLProgram.gl", () {
      expect(glProgram.gl, isNotNull);
    });

    test("GLProgram.program", () {
      expect(glProgram.program, isNotNull);
    });

    test("GLProgram.positionLocation", () {
      expect(glProgram.positionLocation, isNonNegative);
    });

    tearDown(() {
      glCanvas.detach();
    });
  });
}