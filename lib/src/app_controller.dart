part of client;

class AppController {

  static const int _msPerUpdate = 16;

  final App app;
  final AppView appView;
  final Stopwatch _stopwatch;

  int _lag = 0;

  AppController(this.app, this.appView, this._stopwatch);

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
              _stopwatch.reset();
              _lag = 0;
              _update();
              break;
          }
        });

    appView.onNewGameButtonClick.listen((_) {
      var game = new Game.withRandomBoard(20, 24, BlockColor.values.length);
      if (app.startGame(game)) {
        appView.init(game);
      }
      _stopwatch.reset();
      _lag = 0;
      _update();
    });

    app.onNextGameStarted.listen((game) {
      appView.init(game);
      _stopwatch.reset();
      _lag = 0;
      _update();
    });

    appView.onPauseButtonClick.listen((_) {
      app.pauseGame();
      _update();
    });

    appView.onContinueGameButtonClick.listen((_) {
      app.resumeGame();
      _stopwatch.reset();
      _lag = 0;
      _update();
    });

    _stopwatch.start();
  }

  void _update([num delta]) {
    var elapsed = _stopwatch.elapsedMilliseconds;
    _stopwatch.reset();

    _lag += elapsed;

    var scheduleUpdate = true;
    var changed = false;
    for (var i = 0; _lag >= _msPerUpdate; i++) {
      _lag -= _msPerUpdate;
      if (app.update()) {
        changed = true;
      } else {
        scheduleUpdate = false;
        break;
      }
    }

    if (changed) {
      appView.gameView.draw(app.currentGame);
    }

    if (scheduleUpdate) {
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
