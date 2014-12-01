part of tests;

game_view_tests() {

  var gameView;

  group("game_view", () {
    setUp(() {
      gameView = new GameView.attached();
    });

    test("GameView.buttonBar", () {
      expect(gameView.buttonBar, isNotNull);
    });

    test("GameView.glCanvas", () {
      expect(gameView.glCanvas, isNotNull);
    });

    tearDown(() {
      gameView.detach();
    });
  });
}