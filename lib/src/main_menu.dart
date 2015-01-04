part of client;

/// The main menu used to start a new game or continue an existing one.
class MainMenu {

  final DivElement _menu;
  final ButtonElement _continueButton;
  final ButtonElement _newGameButton;
  final Fader _fader;

  /// Whether the continue button is visible in the menu.
  bool continueButtonVisible = false;

  /// Creates the menu with the production DOM tree and content.
  factory MainMenu.withElements() {
    var title = new HeadingElement.h1()
      ..text = "blockcillin"
      ..className = "main-menu-title";

    makeButton(label) => new ButtonElement()
      ..text = label
      ..className = "main-menu-button";

    var continueButton = makeButton("Continue");
    var newGameButton = makeButton("New Game");

    var footer = new ParagraphElement()
      ..text = "© 2014 BM Software v0.1"
      ..className = "main-menu-footer";

    var menu = new DivElement()
      ..className = "main-menu"
      ..append(title)
      ..append(continueButton)
      ..append(newGameButton)
      ..append(footer);

    var fader = new Fader(menu);

    return new MainMenu(menu, continueButton, newGameButton, fader);
  }

  /// Creates the menu out of individual components for testing.
  MainMenu(this._menu, this._continueButton, this._newGameButton, this._fader) {
    _fader
        ..onFadeInStartCallback = _onMenuFadeInStart
        ..onFadeOutEndCallback = _onMenuFadeOutEnd;
  }

  /// Continue button click stream. Listen to this to resume the game.
  ElementStream<MouseEvent> get onContinueButtonClick => _continueButton.onClick;

  /// New game button click stream. Listen to this to start a new game.
  ElementStream<MouseEvent> get onNewGameButtonClick => _newGameButton.onClick;

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