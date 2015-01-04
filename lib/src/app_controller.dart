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
              app.state = AppState.PAUSED;
              _update();
              break;

            case AppState.PAUSED:
              app.state = AppState.PLAYING;
              _update();
              break;
          }
        });

    appView.onContinueGameButtonClick.listen((_) {
      app.state = AppState.PLAYING;
      _update();
    });

    appView.onNewGameButtonClick.listen((_) {
      app.startGame(new Game.withRandomBoard(3, 3));
      _update();
    });

    appView.onPauseButtonClick.listen((_) {
      app.state = AppState.PAUSED;
      _update();
    });
  }

  void _update([num delta]) {
    app.update();

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
        appView.gameView.draw(app._game);
        window.animationFrame.then(_update);
        break;

      case AppState.PAUSED:
        appView.mainMenu.continueButtonVisible = true;
        appView.mainMenu.show();
        appView.gameView.buttonBar.hide();
        break;
    }
  }
}
