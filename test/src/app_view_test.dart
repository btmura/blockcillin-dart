part of tests;

app_view_tests() {

  var appView;

  group("app_view", () {
    setUp(() {
      var mainMenu = new MainMenu();
      var gameView = new GameView.attached();
      appView = new AppView(mainMenu, gameView);
    });

    test("AppView.mainMenu", () {
      expect(appView.mainMenu, isNotNull);
    });

    test("AppView.gameView", () {
      expect(appView.gameView, isNotNull);
    });
  });
}
