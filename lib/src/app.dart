part of client;

/// The model that represents the app which may have a current game.
class App {

  final StreamController<AppState> _stateStream = new StreamController();
  final StreamController<Game> _newGameStream = new StreamController();

  AppState _state = AppState.INITIAL;
  Game _currentGame;
  Game _nextGame;
  StreamSubscription _currentGameSubscription;

  /// Stream that broadcasts when the app's state has changed.
  Stream<AppState> get onAppStateChanged => _stateStream.stream;

  /// Stream that broadcasts when a new game has started.
  Stream<Game> get onNewGameStarted => _newGameStream.stream;

  /// State of the app.
  AppState get state => _state;

  /// Current game being played.
  Game get currentGame => _currentGame;

  /// Request a new game to be started.
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

  /// Returns true if the request to pause the game was accepted.
  void requestPauseGame() {
    if (_currentGame != null) {
      _currentGame.requestPause();
    }
  }

  /// Returns true if the request to resume the game was accepted.
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

/// State that the app can be in.
enum AppState {

  /// No game has ever been started. States never go back to this.
  INITIAL,

  /// Game is starting up.
  STARTING,

  /// Game has been started. Can only go to PAUSED.
  PLAYING,

  /// Game is in the process of pausing.
  PAUSING,

  /// Game has been paused. Can only go to PLAYING.
  PAUSED,

  /// Game is playing the game over animation.
  GAME_OVERING,

  /// Game is over. Can only go to PLAYING.
  GAME_OVER,

  /// Game is in the process of resuming.
  RESUMING,

  /// Game is finishing up.
  FINISHING,

  /// Game is finished.
  FINISHED,
}