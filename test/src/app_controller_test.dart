part of tests;

app_controller_tests() {

  var appController;

  group("app_controller", () {
    setUp(() {
      var app = new App();

      var mainMenu = new MainMenu();

      var buttonBar = new ButtonBar.attached();
      var glCanvas = new GLCanvas.attached();
      var gl = glCanvas.gl;
      var program = new GLProgram(gl);
      var boardRenderer = new BoardRenderer(program);
      var gameView = new GameView(buttonBar, glCanvas, gl, program, boardRenderer);

      var appView = new AppView(mainMenu, gameView);

      appController = new AppController(app, appView);
    });

    test("AppController.app", () {
      expect(appController.app, isNotNull);
    });

    test("AppController.appView", () {
      expect(appController.appView, isNotNull);
    });
  });
}
