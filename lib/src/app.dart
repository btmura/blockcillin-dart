part of client;

/// The model that represents the app which may have a current game.
class App {

  final StreamController<AppState> _stateStream = new StreamController();
  final StreamController<Game> _nextGameStream = new StreamController();

  AppState _state;
  Game _currentGame;
  Game _nextGame;

  /// Stream that broadcasts when the app's state has changed.
  Stream<AppState> get onAppStateChanged => _stateStream.stream;

  /// Stream that broadcasts when the next game has become the current game.
  Stream<Game> get onNextGameStarted => _nextGameStream.stream;

  /// State of the app. Null until the first time update is called.
  AppState get state => _state;

  /// Current game being played.
  Game get currentGame => _currentGame;

  /// Starts a new game and returns true if the game will be started immediately.
  bool startGame(Game newGame) {
    _setState(AppState.PLAYING);

    // Make the new game the current one if there is no current game.
    if (_currentGame == null) {
      _currentGame = newGame;
      return true;
    }

    // Stop the current game and queue up the next game.
    _currentGame.requestStop();
    _nextGame = newGame;
    return false;
  }

  /// Returns true if the request to pause the game was accepted.
  bool requestPauseGame() {
    if (_currentGame != null && _currentGame.requestPause()) {
      _setState(AppState.PAUSED);
      return true;
    }
    return false;
  }

  /// Returns true if the request to resume the game was accepted.
  bool requestResumeGame() {
    if (_currentGame != null && _currentGame.requestResume()) {
      _setState(AppState.PLAYING);
      return true;
    }
    return false;
  }

  /// Returns whether the app has changed after advancing it's state.
  bool update() {
    if (_state == null) {
      _setState(AppState.INITIAL);
    }

    // Update the current game if there is one. Return true if it changed.
    if (_currentGame != null && _currentGame.update()) {
        return true;
    }

    // If there is a next game and the current game isn't changing, then start the next game.
    if (_nextGame != null) {
      _currentGame = _nextGame;
      _nextGame = null;

      // Broadcast that the next game has become the current game.
      if (_currentGame != null && !_nextGameStream.isPaused) {
        _nextGameStream.add(_currentGame);
      }

      return currentGame.update();
    }

    return false;
  }

  void _setState(AppState newState) {
    if (newState != _state) {
      _state = newState;
      if (!_stateStream.isPaused) {
        _stateStream.add(newState);
      }
    }
  }
}

/// State that the app can be in.
class AppState {

  /// No game has ever been started. States never go back to this.
  static const AppState INITIAL = const AppState._(0);

  /// Game has been started. Can only go to PAUSED.
  static const AppState PLAYING = const AppState._(1);

  /// Game has been paused. Can only goto to PLAYING.
  static const AppState PAUSED = const AppState._(2);

  final int index;

  const AppState._(this.index);
}