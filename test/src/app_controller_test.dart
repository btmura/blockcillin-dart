part of tests;

app_controller_tests() {

  var appController;

  group("app_controller", () {
    setUp(() {
      var app = new App();

      var mainMenu = new MainMenu();

      var buttonBar = new ButtonBar(new DivElement(), new ButtonElement());

      var canvas = new CanvasElement();
      var gl = getWebGL(canvas);
      var program = new GLProgram(gl);
      var boardRenderer = new BoardRenderer(program);
      var gameView = new GameView(buttonBar, canvas, gl, program, boardRenderer);

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
