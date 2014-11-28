part of tests;

app_controller_tests() {
  group("app_controller", () {
    test("AppController(app, appView)", () {
      var app = new App();
      var appView = new AppView();
      var appController = new AppController(app, appView);
    });
  });
}
