part of tests;

gl_program_tests() {

  var glCanvas;
  var glProgram;

  group("gl_program", () {
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