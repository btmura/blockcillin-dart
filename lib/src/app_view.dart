part of client;

/// The view that renders the app.
class AppView {

  final MainMenu _mainMenu;
  final GameView _gameView;

  /// Stream that broadcasts when the continue button is clicked.
  ElementStream<MouseEvent> get onContinueButtonClick => _mainMenu.onContinueButtonClick;

  /// Stream that broadcasts when the new game button is clicked.
  ElementStream<MouseEvent> get onNewGameButtonClick => _mainMenu.onNewGameButtonClick;

  /// Stream that broadcasts when the pause button is clicked.
  ElementStream<MouseEvent> get onPauseButtonClick => _gameView.buttonBar.onPauseButtonClick;

  AppView(this._mainMenu, this._gameView);

  void setGame(Game game) {
    _gameView.setGame(game);
  }

  void draw() {
    _gameView.draw();
  }

  bool resize() {
    _mainMenu.center();
    return _gameView.resize();
  }

  void showInitialView() {
    _mainMenu.continueButtonVisible = false;
    _mainMenu.show();
    _gameView.buttonBar.hide();
  }

  void showPlayingView() {
    _mainMenu.continueButtonVisible = false;
    _mainMenu.hide();
    _gameView.buttonBar.show();
  }

  void showPausedView() {
    _mainMenu.continueButtonVisible = true;
    _mainMenu.show();
    _gameView.buttonBar.hide();
  }
}

