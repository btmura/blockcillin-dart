part of client;

class MainMenu {

  final DivElement _mainMenu;
  final ButtonElement _continueGameButton;
  final ButtonElement _newGameButton;

  MainMenu(this._mainMenu, this._continueGameButton, this._newGameButton);

  ElementStream<MouseEvent> get onContinueGameButtonClick => _continueGameButton.onClick;
  ElementStream<MouseEvent> get onNewGameButtonClick => _newGameButton.onClick;

  void set visible(bool visible) {
    if (visible) {
      _show();
    } else {
      _hide();
    }
  }

  void set continueGameButtonVisible(bool visible) {
    _continueGameButton.style.display = visible ? "block" : "none";
  }

  void _show() {
    // Add menu first to calculate it's height before centering it.
    document.body.children.add(_mainMenu);
    _centerVertically();
  }

  void _hide() {
    _mainMenu.remove();
  }

  void _centerVertically() {
    var top = math.max(document.body.clientHeight - _mainMenu.clientHeight, 0.0) / 2.0;
    _mainMenu.style.top = "${top}px";
  }
}