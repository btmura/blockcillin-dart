part of test;

_app_view_tests() {

  var appView;

  group("app_view", () {
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

class MockMainMenu extends Mock implements MainMenu {
  noSuchMethod(Invocation invocation) {}
}

class MockGameView extends Mock implements GameView {
  noSuchMethod(Invocation invocation) {}
}
