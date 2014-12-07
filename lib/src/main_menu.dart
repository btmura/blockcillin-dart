part of client;

class MainMenu {

  final DivElement _mainMenu;
  final ButtonElement _newGameButton;

  MainMenu(this._mainMenu, this._newGameButton);

  ElementStream<MouseEvent> get onNewGameButtonClick => _newGameButton.onClick;

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