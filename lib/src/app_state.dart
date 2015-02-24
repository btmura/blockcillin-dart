part of blockcillin;

/// State of the app.
enum AppState {

  /// Initial state where no game has ever been started. No animation.
  INITIAL,

  /// State where the game is starting and animating.
  STARTING,

  /// State where the player is playing the game.
  PLAYING,

  /// State where the game is pausing and animating.
  PAUSING,

  /// State where the game is paused. No animation.
  PAUSED,

  /// State where the game is resuming and animating.
  RESUMING,

  /// State where the player lost and the game is animating.
  GAME_OVERING,

  /// State where the game is over. No animation.
  GAME_OVER,

  /// State where the current game is animated away for a new game.
  FINISHING,

  /// State where the current game is gone. No animation.
  FINISHED,
}