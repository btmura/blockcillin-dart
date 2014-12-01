part of tests;

app_view_tests() {

  var appView;

  group("app_view", () {
    setUp(() {
      appView = new AppView.attached();
    });

    test("AppView.mainMenu", () {
      expect(appView.mainMenu, isNotNull);
    });

    test("AppView.gameView", () {
      expect(appView.gameView, isNotNull);
    });

    tearDown(() {
      appView.detach();
    });
  });
}
