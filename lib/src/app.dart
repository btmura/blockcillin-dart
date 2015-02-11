part of client;

/// The model that represents the app which may have a current game.
class App {

  /// State of the app.
  AppState _state = AppState.INITIAL;

  /// Current game being played or ending. Null only once at the start.
  Game _currentGame;

  /// Next game queued to become the current game. Often null.
  Game _nextGame;

  /// StreamController that emits the next game when it becomes the current game.
  StreamController<Game> _nextGameStream = new StreamController();

  /// Current game being played.
  Game get currentGame => _currentGame;

  /// Stream that broadcasts when the next game has become the current game.
  Stream<Game> get onNextGameStarted => _nextGameStream.stream;

  AppState get state => _state;

  /// Starts a new game and returns true if the game will be started immediately.
  bool startGame(Game newGame) {
    _state = AppState.PLAYING;

    // Make the new game the current one if there is no current game.
    if (_currentGame == null) {
      _currentGame = newGame;
      return true;
    }

    // Start ending the current game and queue up the next game.
    _currentGame.finish();
    _nextGame = newGame;
    return false;
  }

  /// Pauses the current game if there is one.
  void pauseGame() {
    if (_currentGame != null && _currentGame.pause()) {
      _state = AppState.PAUSED;
    }
  }

  /// Resumes the current game if there is one.
  void resumeGame() {
    if (_currentGame != null && _currentGame.resume()) {
      _state = AppState.PLAYING;
    }
  }

  /// Returns whether the app has changed after advancing it's state.
  bool update() {
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