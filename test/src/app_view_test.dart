part of tests;

app_view_tests() {

  var appView;

  group("app_view", () {
    setUp(() {
      var mainMenu = new MainMenu();
      var buttonBar = new ButtonBar(new DivElement(), new ButtonElement());
      var canvas = new CanvasElement();
      var gl = getWebGL(canvas);
      var program = new GLProgram(gl);
      var boardRenderer = new BoardRenderer(program);
      var gameView = new GameView(buttonBar, canvas, gl, program, boardRenderer);
      appView = new AppView(mainMenu, gameView);
    });

    test("AppView.mainMenu", () {
      expect(appView.mainMenu, isNotNull);
    });

    test("AppView.gameView", () {
      expect(appView.gameView, isNotNull);
    });
  });
}
