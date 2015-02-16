part of client;

/// The view that renders the app.
class AppView {

  final MainMenu _mainMenu;
  final GameView _gameView;

  AppView(this._mainMenu, this._gameView);

  /// Stream that broadcasts when the continue button is clicked.
  ElementStream<MouseEvent> get onContinueButtonClick => _mainMenu.onContinueButtonClick;

  /// Stream that broadcasts when the new game button is clicked.
  ElementStream<MouseEvent> get onNewGameButtonClick => _mainMenu.onNewGameButtonClick;

  /// Stream that broadcasts when the pause button is clicked.
  ElementStream<MouseEvent> get onPauseButtonClick => _gameView.buttonBar.onPauseButtonClick;

  void setGame(Game newGame) {
    _gameView.setGame(newGame);
  }

  void setState(AppState newState) {
    _mainMenu.setState(newState);
    switch (newState) {
      case AppState.INITIAL:
      case AppState.PAUSING:
      case AppState.GAME_OVERING:
        _mainMenu.show();
        _gameView.buttonBar.hide();
        break;

      case AppState.PAUSED:
      case AppState.GAME_OVER:
      case AppState.FINISHED:
        break;

      case AppState.STARTING:
      case AppState.RESUMING:
        _mainMenu.hide();
        _gameView.buttonBar.hide();
        break;

      case AppState.PLAYING:
        _mainMenu.hide();
        _gameView.buttonBar.show();
        break;

      case AppState.FINISHING:
        _mainMenu.hide();
        _gameView.buttonBar.hide();
        break;
    }
  }

  void draw() {
    _gameView.draw();
  }

  bool resize() {
    _mainMenu.center();
    return _gameView.resize();
  }
}
