part of test;

_app_tests() {
  group("app", () {
    MockGame mockGame;
    App app;

    setUp(() {
      mockGame = new MockGame();
      app = new App();
    });

    test("App", () {
      expect(app.state, equals(AppState.INITIAL));
    });

    test("App.startGame", () {
      app.startGame(mockGame);
      expect(app.state, equals(AppState.PLAYING));
    });

    test("App.update", () {
      app.update();
      verify(mockGame.update()).never();

      app.startGame(mockGame);
      app.update();
      verify(mockGame.update()).times(1);
    });
  });
}
