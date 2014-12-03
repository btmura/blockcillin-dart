part of tests;

game_view_tests() {

  var gameView;

  group("game_view", () {
    setUp(() {
      var buttonBar = new ButtonBar(new DivElement(), new ButtonElement());
      var glCanvas = new GLCanvas.attached();
      var gl = glCanvas.gl;
      var program = new GLProgram(gl);
      var boardRenderer = new BoardRenderer(program);
      gameView = new GameView(buttonBar, glCanvas, gl, program, boardRenderer);
    });

    test("GameView.buttonBar", () {
      expect(gameView.buttonBar, isNotNull);
    });

    test("GameView.glCanvas", () {
      expect(gameView.glCanvas, isNotNull);
    });
  });
}