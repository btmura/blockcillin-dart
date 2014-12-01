part of tests;

app_controller_tests() {

  var appController;

  group("app_controller", () {
    setUp(() {
      appController = new AppController.append();
    });

    test("AppController.app", () {
      expect(appController.app, isNotNull);
    });

    test("AppController.appView", () {
      expect(appController.appView, isNotNull);
    });

    tearDown(() {
      appController.remove();
    });
  });
}
