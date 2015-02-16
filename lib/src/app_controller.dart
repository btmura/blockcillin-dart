part of client;

class AppController {

  static const int _msPerUpdate = 8;

  final App _app;
  final AppView _appView;
  final Stopwatch _stopwatch;

  int _lag = 0;

  AppController(this._app, this._appView, this._stopwatch);

  void run() {
    _init();
    _update();
  }

  void _init() {
    _appView.resize();

    window.onResize.listen((_) {
      if (_appView.resize()) {
        _scheduleUpdate();
      }
    });

    window.onKeyUp
        .where((event) => event.keyCode == KeyCode.ESC)
        .listen((_) {
          switch (_app.state) {
            case AppState.INITIAL:
            case AppState.STARTING:
            case AppState.PAUSING:
            case AppState.RESUMING:
            case AppState.GAME_OVERING:
            case AppState.GAME_OVER:
            case AppState.FINISHING:
            case AppState.FINISHED:
              break;

            case AppState.PLAYING:
              _app.requestPauseGame();
              _scheduleUpdate();
              break;

            case AppState.PAUSED:
              _app.requestResumeGame();
              _scheduleUpdate();
              break;
          }
        });

    _app.onAppStateChanged.listen((state) => _appView.setState(state));

    _appView.onNewGameButtonClick.listen((_) {
      var game = new Game.withRandomBoard(20, 24, BlockColor.values.length);
      _app.requestNewGame(game);
      _scheduleUpdate();
    });

    _app.onNewGameStarted.listen((game) {
      _appView.setGame(game);
      _scheduleUpdate();
    });

    _appView.onPauseButtonClick.listen((_) {
      _app.requestPauseGame();
      _scheduleUpdate();
    });

    _appView.onContinueButtonClick.listen((_) {
      _app.requestResumeGame();
      _scheduleUpdate();
    });

    _appView.setState(_app.state);
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

    _appView.draw();

    if (scheduleUpdate) {
      _scheduleUpdate();
    } else {
      _stopwatch.stop();
      _stopwatch.reset();
      _lag = 0;
    }
  }

  void _scheduleUpdate() {
    window.animationFrame.then(_update);
  }
}
