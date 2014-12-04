part of client;

class MainMenu {

  final DivElement _mainMenu;
  final ButtonElement _newGameButton;

  factory MainMenu() {
    var newGameButton = new ButtonElement()
        ..id = "new-game-button"
        ..text = "New Game";

    var mainMenu = new DivElement()
        ..id = "main-menu"
        ..className = "menu"
        ..append(newGameButton);

    return new MainMenu._(mainMenu, newGameButton);
  }

  MainMenu._(this._mainMenu, this._newGameButton);

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