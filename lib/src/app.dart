part of client;

/// The model that represents the app which may have a current game.
class App {

  /// State of the app.
  AppState state = AppState.INITIAL;

  Game _game;

  /// Starts a new game replacing the old one if it exists.
  void startGame(Game newGame) {
    state = AppState.PLAYING;
    _game = newGame;
  }

  /// Updates the app. Call this 1 or more times per game loop iteration.
  void update() {
    if (_game != null) {
      _game.update();
    }
  }
}

/// State that the app can be in.
enum AppState {

  /// No game has ever been started. States never go back to this.
  INITIAL,

  /// Game has been started. Can only go to PAUSED.
  PLAYING,

  /// Game has been paused. Can only goto to PLAYING.
  PAUSED
}