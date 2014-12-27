part of client;

class MainMenu {

  final DivElement _mainMenu;
  final ButtonElement _continueGameButton;
  final ButtonElement _newGameButton;

  bool _mainMenuVisible;
  bool _continueGameButtonVisible;

  MainMenu(this._mainMenu, this._continueGameButton, this._newGameButton);

  ElementStream<MouseEvent> get onContinueGameButtonClick => _continueGameButton.onClick;
  ElementStream<MouseEvent> get onNewGameButtonClick => _newGameButton.onClick;

  void set visible(bool visible) {
    if (_mainMenuVisible == visible) {
      return;
    }

    print("main menu visible: $visible");

    if (visible) {
      _show();
    } else {
      _hide();
    }
  }

  void set continueGameButtonVisible(bool visible) {
    if (_continueGameButtonVisible == visible) {
      return;
    }

    print("continue game button visible: $visible");

    _continueGameButton.style.display = visible ? "inline-block" : "none";
    _continueGameButtonVisible = visible;
  }

  void _show() {
    // Add menu first to calculate it's height before centering it.
    document.body.children.add(_mainMenu);
    _centerVertically();
    _mainMenuVisible = true;
  }

  void _hide() {
    _mainMenu.remove();
    _mainMenuVisible = false;
  }

  void _centerVertically() {
    var top = math.max(document.body.clientHeight - _mainMenu.clientHeight, 0.0) / 2.0;
    _mainMenu.style.top = "${top}px";
  }
}