part of test;

_game_view_tests() {

  var gameView;

  group("game_view", () {
    setUp(() {
      var buttonBar = new ButtonBar(new DivElement(), new ButtonElement());
      var canvas = new CanvasElement();
      var gl = getWebGL(canvas);
      var program = new GLProgram(gl);
      var boardRenderer = new BoardRenderer(program);
      gameView = new GameView(buttonBar, canvas, gl, program, boardRenderer);
    });

    test("GameView.buttonBar", () {
      expect(gameView.buttonBar, isNotNull);
    });

    test("GameView.glCanvas", () {
      expect(gameView.canvas, isNotNull);
    });
  });
}