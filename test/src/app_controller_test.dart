part of tests;

app_controller_tests() {

  var appController;

  group("app_controller", () {
    setUp(() {
      var app = new App();
      var appView = new AppView.attached();
      appController = new AppController(app, appView);
    });

    test("AppController.app", () {
      expect(appController.app, isNotNull);
    });

    test("AppController.appView", () {
      expect(appController.appView, isNotNull);
    });

    tearDown(() {
      appController.detach();
    });
  });
}
