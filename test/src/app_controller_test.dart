part of tests;

app_controller_tests() {

  var mockApp;
  var mockAppView;
  var appController;

  group("app_controller", () {
    setUp(() {
      mockApp = new MockApp();
      mockAppView = new MockAppView();
      appController = new AppController(mockApp, mockAppView);
    });

    test("AppController.app", () {
      expect(appController.app, isNotNull);
    });

    test("AppController.appView", () {
      expect(appController.appView, isNotNull);
    });
  });
}

class MockApp extends Mock implements App {
  noSuchMethod(Invocation invocation) {}
}

class MockAppView extends Mock implements AppView {
  noSuchMethod(Invocation invocation) {}
}