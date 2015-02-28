part of blockcillin;

/// The main menu used to start a new game or continue an existing one.
class MainMenu {

  final DivElement _menu;
  final HeadingElement _title;
  final ButtonElement _continueButton;
  final ButtonElement _newGameButton;
  final Fader _fader;

  bool continueButtonVisible = false;

  /// Creates the menu with the production DOM tree and content.
  factory MainMenu() {
    var title = new HeadingElement.h1();
    title.className = "main-menu-title";

    ButtonElement makeButton(label) {
      var button = new ButtonElement();
      button.text = label;
      button.className = "main-menu-button";
      return button;
    }

    var continueButton = makeButton("Continue");
    var newGameButton = makeButton("New Game");

    var footer = new ParagraphElement();
    footer.text = "© 2014 BM Software v0.1";
    footer.className = "main-menu-footer";

    var menu = new DivElement();
    menu.className = "main-menu";
    menu.append(title);
    menu.append(continueButton);
    menu.append(newGameButton);
    menu.append(footer);

    var fader = new Fader(menu);

    return new MainMenu._(menu, title, continueButton, newGameButton, fader);
  }

  MainMenu._(this._menu, this._title, this._continueButton, this._newGameButton, this._fader) {
    _fader.onFadeInStartCallback = _onMenuFadeInStart;
    _fader.onFadeOutEndCallback = _onMenuFadeOutEnd;
  }

  /// Continue button click stream. Listen to this to resume the game.
  ElementStream<MouseEvent> get onContinueButtonClick => _continueButton.onClick;

  /// New game button click stream. Listen to this to start a new game.
  ElementStream<MouseEvent> get onNewGameButtonClick => _newGameButton.onClick;

  void set title(String newTitle) {
    _title.text = newTitle;
  }

  /// Shows the menu gradually.
  void show() {
    _fader.fadeIn();
  }

  /// Hides the menu gradually.
  void hide() {
    _fader.fadeOut();
  }

  /// Centers the main menu instantly. Call this when the window is resized.
  void center() {
    // Just center vertically because the menu takes 100% of the window's width.
    var top = math.max(document.body.clientHeight - _menu.clientHeight, 0.0) / 2.0;
    _menu.style.top = "${top}px";
  }

  void _onMenuFadeInStart() {
    // TODO(btmura): extract toggling of display style to utility class
    _continueButton.style.display = continueButtonVisible ? "block" : "none";

    // Add menu first to give it some dimensions before centering it.
    document.body.children.add(_menu);

    center();
  }

  void _onMenuFadeOutEnd() {
    _menu.remove();
  }
}
