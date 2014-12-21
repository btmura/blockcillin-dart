part of client;

class MainMenu {

  final DivElement _mainMenu;
  final ButtonElement _continueGameButton;
  final ButtonElement _newGameButton;

  MainMenu(this._mainMenu, this._continueGameButton, this._newGameButton);

  ElementStream<MouseEvent> get onContinueGameButtonClick => _continueGameButton.onClick;

  ElementStream<MouseEvent> get onNewGameButtonClick => _newGameButton.onClick;

  void set continueGameButtonVisible(bool visible) {
    if (visible) {
      _continueGameButton.style.display = "inline-block";
    } else {
      _continueGameButton.style.display = "none";
    }
  }

  void set visible(bool visible) {
    if (visible) {
      _show();
    } else {
      _hide();
    }
  }

  void _show() {
    document.body.children.add(_mainMenu);
  }

  void _hide() {
    _mainMenu.remove();
  }
}