part of test;

_app_tests() {

  var app;

  group("app", () {
    setUp(() {
      app = new App();
    });

    test("App", () {
      expect(app.gameStarted, isFalse);
      expect(app.gamePaused, isFalse);
      expect(app.game, isNull);
    });

    test("App.startGame", () {
      var game = new Game.withRandomBoard(3, 3);
      app.startGame(game);
      expect(app.gameStarted, isTrue);
      expect(app.gamePaused, isFalse);
      expect(app.game, equals(game));
    });
  });
}
