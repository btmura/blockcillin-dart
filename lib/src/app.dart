part of client;

/// The model that represents the app which may have a current game.
class App {

  /// State of the app.
  AppState state = AppState.INITIAL;

  /// Current game being played or ending. Null only once at the start.
  Game _currentGame;

  /// Next game queued to become the current game. Often null.
  Game _nextGame;

  /// StreamController that emits the next game when it becomes the current game.
  StreamController<Game> _nextGameController = new StreamController();

  /// Current game being played.
  Game get currentGame => _currentGame;

  /// Stream that broadcasts when the next game has become the current game.
  Stream<Game> get onNextGameStarted => _nextGameController.stream;

  /// Starts a new game and returns true if the game will be started immediately.
  bool startGame(Game newGame) {
    state = AppState.PLAYING;

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

  /// Updates the app. Call this 1 or more times per game loop iteration.
  void update() {
    // Switch to the next game if the current game is done (ending sequence finished).
    if (_currentGame != null && _currentGame.finished) {
      _currentGame = _nextGame;
      _nextGame = null;

      // Broadcast that the next game has become the current game.
      if (_currentGame != null && !_nextGameController.isPaused) {
        _nextGameController.add(_currentGame);
      }
    }

    // Update the current game if there is one.
    if (_currentGame != null) {
      _currentGame.update();
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