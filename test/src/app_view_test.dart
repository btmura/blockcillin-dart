part of test;

_app_view_tests() {
  group("app_view", () {
    AppView appView;

    setUp(() {
      var mockMainMenu = new MockMainMenu();
      var mockGameView = new MockGameView();
      appView = new AppView(mockMainMenu, mockGameView);
    });

    test("AppView.mainMenu", () {
      expect(appView.mainMenu, isNotNull);
    });

    test("AppView.gameView", () {
      expect(appView.gameView, isNotNull);
    });
  });
}