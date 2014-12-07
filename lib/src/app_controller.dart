part of client;

class AppController {

  final App app;
  final AppView appView;

  AppController(this.app, this.appView);

  void run() {
    _init();
    _update();
  }

  void _init() {
    appView.gameView.resize();

    window.onResize.listen((_) {
      if (appView.gameView.resize()) {
        _update();
      }
    });

    window.onKeyUp
        .where((event) => event.keyCode == KeyCode.ESC)
        .listen((_) {
          if (app.gameStarted) {
            app.gamePaused = !app.gamePaused;
            _update();
          }
        });

    appView.mainMenu.onNewGameButtonClick.listen((_) {
      app.startGame(new Game.withRandomBoard(3, 3));
      _update();
    });

    appView.gameView.buttonBar.onPauseButtonClick.listen((_) {
      app.gamePaused = true;
      _update();
    });
  }

  void _update([num delta]) {
    app.update();

    appView.mainMenu.visible = !app.gameStarted || app.gamePaused;
    appView.gameView.buttonBar.visible = app.gameStarted && !app.gamePaused;
    if (app.game != null) {
      appView.gameView.draw(app.game);
    }

    if (app.gameStarted && !app.gamePaused) {
      window.animationFrame.then(_update);
    }
  }
}
