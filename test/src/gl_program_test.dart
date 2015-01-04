part of test;

_gl_program_tests() {
  group("gl_program", () {
    GLProgram glProgram;

    setUp(() {
      var canvas = new CanvasElement();
      var gl = getWebGL(canvas);
      glProgram = new GLProgram(gl);
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
  });
}