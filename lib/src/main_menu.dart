part of client;

class MainMenu {

  final DivElement _mainMenu;
  final ButtonElement _continueGameButton;
  final ButtonElement _newGameButton;
  final Fader _fader;

  bool _continueGameButtonVisible;

  factory MainMenu(DivElement mainMenu, ButtonElement continueGameButton, ButtonElement newGameButton) {
    Fader fader = new Fader(mainMenu);
    return new MainMenu._(mainMenu, continueGameButton, newGameButton, fader);
  }

  MainMenu._(this._mainMenu, this._continueGameButton, this._newGameButton, this._fader) {
    this._fader
        ..fadeInStartCallback = _onFadeInStart
        ..fadeOutEndCallback = _onFadeOutEnd;
  }

  ElementStream<MouseEvent> get onContinueGameButtonClick => _continueGameButton.onClick;
  ElementStream<MouseEvent> get onNewGameButtonClick => _newGameButton.onClick;

  void set continueGameButtonVisible(bool visible) {
    _continueGameButtonVisible = visible;
  }

  // TODO(btmura): replace with function since this isn't a quick immediate operation
  void set visible(bool visible) {
    _fader.fade = visible;
  }

  /// Centers the main menu. Call this when the window is resized.
  void center() {
    _centerVertically();
  }

  void _onFadeInStart() {
    // Add menu first to calculate it's height before centering it.
    _continueGameButton.style.display = _continueGameButtonVisible ? "block" : "none";
    document.body.children.add(_mainMenu);
    _centerVertically();
  }

  void _onFadeOutEnd() {
    _mainMenu.remove();
  }

  void _centerVertically() {
    var top = math.max(document.body.clientHeight - _mainMenu.clientHeight, 0.0) / 2.0;
    _mainMenu.style.top = "${top}px";
  }
}