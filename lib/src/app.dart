part of client;

/// Model of the app which manages the current game and the next game.
class App {

  final StreamController<AppState> _stateStream = new StreamController();
  final StreamController<Game> _newGameStream = new StreamController();

  AppState _state = AppState.INITIAL;
  Game _currentGame;
  Game _nextGame;
  StreamSubscription _currentGameSubscription;

  /// State of the app.
  AppState get state => _state;

  /// Stream that broadcasts when the app's state has changed.
  Stream<AppState> get onAppStateChanged => _stateStream.stream;

  /// Stream that broadcasts when a new game has started.
  Stream<Game> get onNewGameStarted => _newGameStream.stream;

  /// Requests a new game to be started.
  void requestNewGame(Game newGame) {
    // Make the new game the current one if there is no current game.
    if (_currentGame == null) {
      _setCurrentGame(newGame);
      return;
    }

    // Stop the current game and queue up the next game.
    _currentGame.requestFinish();
    _nextGame = newGame;
  }

  /// Requests the current game to be paused.
  void requestPauseGame() {
    if (_currentGame != null) {
      _currentGame.requestPause();
    }
  }

  /// Requests the current game to be resumed.
  void requestResumeGame() {
    if (_currentGame != null) {
      _currentGame.requestResume();
    }
  }

  /// Returns whether the app has changed after advancing it's state.
  bool update() {
    return _currentGame != null && _currentGame.update();
  }

  void _setCurrentGame(Game newGame) {
    if (_currentGameSubscription != null) {
      _currentGameSubscription.cancel();
    }
    _currentGame = newGame;
    _currentGameSubscription = _currentGame.onAppStateChanged.listen(_setState);
    _nextGame = null;

    if (!_newGameStream.isPaused) {
      _newGameStream.add(_currentGame);
    }
  }

  void _setState(AppState newState) {
    if (newState != _state) {
      _state = newState;
      if (!_stateStream.isPaused) {
        _stateStream.add(newState);
      }

      if (_state == AppState.FINISHED && _nextGame != null) {
        _setCurrentGame(_nextGame);
      }
    }
  }
}
