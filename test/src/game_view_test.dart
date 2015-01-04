part of test;

_game_view_tests() {
  group("game_view", () {
    GameView gameView;

    setUp(() {
      var buttonBarElement = new DivElement();
      var pauseButton = new ButtonElement();
      var fader = new Fader(buttonBarElement);
      var buttonBar = new ButtonBar(buttonBarElement, pauseButton, fader);

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