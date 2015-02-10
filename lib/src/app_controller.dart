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
    appView.resize();

    window.onResize.listen((_) {
      if (appView.resize()) {
        _update();
      }
    });

    window.onKeyUp
        .where((event) => event.keyCode == KeyCode.ESC)
        .listen((_) {
          switch (app.state) {
            case AppState.INITIAL:
              break;

            case AppState.PLAYING:
              app.pauseGame();
              _update();
              break;

            case AppState.PAUSED:
              app.resumeGame();
              _update();
              break;
          }
        });

    appView.onNewGameButtonClick.listen((_) {
      var game = new Game.withRandomBoard(20, 24, BlockColor.values.length);
      if (app.startGame(game)) {
        appView.init(game);
      }
      _update();
    });

    app.onNextGameStarted.listen((game) {
      appView.init(game);
      _update();
    });

    appView.onPauseButtonClick.listen((_) {
      app.pauseGame();
      _update();
    });

    appView.onContinueGameButtonClick.listen((_) {
      app.resumeGame();
      _update();
    });
  }

  void _update([num delta]) {
    if (app.update()) {
        appView.gameView.draw(app.currentGame);
        window.animationFrame.then(_update);
    }

    // TODO(btmura): don't call setters on every frame unless something changes

    switch (app.state) {
      case AppState.INITIAL:
        appView.mainMenu.continueButtonVisible = false;
        appView.mainMenu.show();
        appView.gameView.buttonBar.hide();
        break;

      case AppState.PLAYING:
        appView.mainMenu.continueButtonVisible = false;
        appView.mainMenu.hide();
        appView.gameView.buttonBar.show();
        break;

      case AppState.PAUSED:
        appView.mainMenu.continueButtonVisible = true;
        appView.mainMenu.show();
        appView.gameView.buttonBar.hide();
        break;
    }
  }
}
