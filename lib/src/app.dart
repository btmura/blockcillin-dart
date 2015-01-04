part of client;

/// The model represeting the app.
class App {

  AppState state = AppState.INITIAL;

  Game _game;

  /// Starts a new game. Throws out the old game.
  void startGame(Game newGame) {
    state = AppState.PLAYING;
    _game = newGame;
  }

  /// Updates the app. Call this on each game loop cycle.
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