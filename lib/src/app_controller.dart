part of client;

class AppController {

  static const int _msPerUpdate = 8;

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
        _scheduleUpdate();
      }
    });

    window.onKeyUp
        .where((event) => event.keyCode == KeyCode.ESC)
        .listen((_) {
          switch (app.state) {
            case AppState.INITIAL:
              break;

            case AppState.PLAYING:
              app.requestPauseGame();
              _scheduleUpdate();
              break;

            case AppState.PAUSED:
              app.requestResumeGame();
              _stopwatch.reset();
              _lag = 0;
              _scheduleUpdate();
              break;
          }
        });

    app.onAppStateChanged.listen((state) => _refreshView(state));

    appView.onNewGameButtonClick.listen((_) {
      var game = new Game.withRandomBoard(20, 24, BlockColor.values.length);
      app.startGame(game);
      _scheduleUpdate();
    });

    app.onNewGameStarted.listen((game) {
      appView.init(game);
      _stopwatch.reset();
      _lag = 0;
      _scheduleUpdate();
    });

    appView.onPauseButtonClick.listen((_) {
      app.requestPauseGame();
      _scheduleUpdate();
    });

    appView.onContinueGameButtonClick.listen((_) {
      app.requestResumeGame();
      _stopwatch.reset();
      _lag = 0;
      _scheduleUpdate();
    });

    _refreshView(app.state);
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
      _scheduleUpdate();
    }
  }

  void _refreshView(AppState state) {
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

  void _scheduleUpdate() {
    window.animationFrame.then(_update);
  }
}
