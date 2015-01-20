part of client;

/// The model that represents the app which may have a current game.
class App {

  /// State of the app.
  AppState state = AppState.INITIAL;

  /// Queue of games to be played. First element is the current game.
  List<Game> _games = [];

  /// Current game being played.
  Game get game => _games.first;

  /// Starts a new game after ending the current game.
  void startGame(Game newGame) {
    state = AppState.PLAYING;

    // End the current game if it exists.
    if (_games.isNotEmpty) {
      _games.first.end();
    }

    // Queue the new game.
    _games.add(newGame);
  }

  /// Updates the app. Call this 1 or more times per game loop iteration.
  void update() {
    // Remove the current game if it no longer can be updated (ending animation is done).
    if (_games.isNotEmpty && !_games.first.hasUpdates) {
      _games.removeAt(0);
    }

    // Update the current game if it exists.
    if (_games.isNotEmpty) {
      _games.first.update();
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