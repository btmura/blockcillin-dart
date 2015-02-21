part of client;

/// Controller of the app that connects the model and view together via events.
class AppController {

  static const int _msPerUpdate = 8;

  final App _app;
  final MainMenu _mainMenu;
  final GameView _gameView;
  final Stopwatch _stopwatch;
  int _lag = 0;

  AppController(this._app, this._mainMenu, this._gameView, this._stopwatch);

  /// Run the application.
  void run() {
    _init();
    _update();
  }

  void _init() {
    _resize();

    window.onResize.listen((_) {
      if (_resize()) {
        _scheduleUpdate();
      }
    });

    window.onKeyUp
        .where((event) => event.keyCode == KeyCode.ESC)
        .listen((_) {
          _app.requestToggleGame();
          _scheduleUpdate();
        });

    _app.onAppStateChanged.listen((state) => _refresh(state));

    _mainMenu.onNewGameButtonClick.listen((_) {
      var game = new Game.withRandomBoard(20, 24, BlockColor.values.length);
      _app.requestNewGame(game);
      _scheduleUpdate();
    });

    _app.onNewGameStarted.listen((game) {
      _gameView.setGame(game);
      _scheduleUpdate();
    });

    _gameView.buttonBar.onPauseButtonClick.listen((_) {
      _app.requestPauseGame();
      _scheduleUpdate();
    });

    _mainMenu.onContinueButtonClick.listen((_) {
      _app.requestResumeGame();
      _scheduleUpdate();
    });

    _refresh(_app.state);
    _stopwatch.start();
  }

  void _update([num delta]) {
    var elapsed = _stopwatch.elapsedMilliseconds;
    _lag += elapsed;

    _stopwatch.reset();
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }

    var scheduleUpdate = true;
    for (var i = 0; _lag >= _msPerUpdate; i++) {
      _lag -= _msPerUpdate;
      if (!_app.update()) {
        scheduleUpdate = false;
        break;
      }
    }

    _gameView.draw();

    if (scheduleUpdate) {
      _scheduleUpdate();
    } else {
      _stopwatch.stop();
      _stopwatch.reset();
      _lag = 0;
    }
  }

  bool _resize() {
    _mainMenu.center();
    return _gameView.resize();
  }

  void _scheduleUpdate() {
    window.animationFrame.then(_update);
  }

  void _refresh(AppState newState) {
    switch (newState) {
      case AppState.INITIAL:
        _mainMenu.continueButtonVisible = false;
        _mainMenu.title = "blockcillin";
        _mainMenu.show();
        _gameView.buttonBar.hide();
        break;

      case AppState.STARTING:
        _mainMenu.hide();
        _gameView.buttonBar.hide();
        break;

      case AppState.PLAYING:
        _mainMenu.continueButtonVisible = false;
        _mainMenu.title = "blockcillin";
        _mainMenu.hide();
        _gameView.buttonBar.show();
        break;

      case AppState.PAUSING:
        _mainMenu.continueButtonVisible = true;
        _mainMenu.title = "PAUSED";
        _mainMenu.show();
        _gameView.buttonBar.hide();
        break;

      case AppState.PAUSED:
        break;

      case AppState.RESUMING:
        _mainMenu.hide();
        _gameView.buttonBar.hide();
        break;

      case AppState.GAME_OVERING:
        _mainMenu.continueButtonVisible = false;
        _mainMenu.title = "GAME OVER";
        _mainMenu.show();
        _gameView.buttonBar.hide();
        break;

      case AppState.GAME_OVER:
        break;

      case AppState.FINISHING:
        _mainMenu.hide();
        _gameView.buttonBar.hide();
        break;

      case AppState.FINISHED:
        break;
    }
  }
}
