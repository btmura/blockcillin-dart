library main_menu;

import 'dart:html';

class MainMenu {

  DivElement _mainMenu;
  ButtonElement _newGameButton;

  MainMenu() {
    _mainMenu = new DivElement()
        ..id = "main-menu"
        ..className = "menu"
        ..append(new ButtonElement()
            ..id = "new-game-button"
            ..text = "New Game");
    _newGameButton = _mainMenu.querySelector("#new-game-button");
  }

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