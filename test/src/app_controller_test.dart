part of test;

_app_controller_tests() {
  group("app_controller", () {
    MockApp mockApp;
    MockAppView mockAppView;
    AppController appController;

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