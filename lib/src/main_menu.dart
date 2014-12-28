part of client;

class MainMenu {

  final DivElement _menu;
  final Fader _menuFader;
  final ButtonElement _continueButton;
  final ButtonElement _newGameButton;

  /// Whether the continue button is visible in the menu.
  bool continueButtonVisible;

  /// Creates the menu with the production DOM tree and content.
  factory MainMenu.withElements() {
    var title = new HeadingElement.h1()
      ..text = "blockcillin"
      ..className = "main-menu-title";

    var continueButton = new ButtonElement()
      ..text = "Continue"
      ..className = "main-menu-button";

    var newGameButton = new ButtonElement()
      ..text = "New Game"
      ..className = "main-menu-button";

    var footer = new ParagraphElement()
      ..text = "© 2014 BM Software v0.1"
      ..className = "main-menu-footer";

    var menu = new DivElement()
      ..className = "main-menu"
      ..append(title)
      ..append(continueButton)
      ..append(newGameButton)
      ..append(footer);

    var menuFader = new Fader(menu);

    return new MainMenu(menu, menuFader, continueButton, newGameButton);
  }

  /// Creates the menu out of individual components for testing.
  MainMenu(this._menu, this._menuFader, this._continueButton, this._newGameButton) {
    _menuFader
        ..onFadeInStartCallback = _onMenuFadeInStart
        ..onFadeOutEndCallback = _onMenuFadeOutEnd;
  }

  ElementStream<MouseEvent> get onContinueButtonClick => _continueButton.onClick;
  ElementStream<MouseEvent> get onNewGameButtonClick => _newGameButton.onClick;

  // TODO(btmura): replace with function since this isn't a quick immediate operation
  void set visible(bool visible) {
    if (visible) {
      _menuFader.fadeIn();
    } else {
      _menuFader.fadeOut();
    }
  }

  /// Centers the main menu. Call this when the window is resized.
  void center() {
    _centerVertically();
  }

  void _centerVertically() {
    var top = math.max(document.body.clientHeight - _menu.clientHeight, 0.0) / 2.0;
    _menu.style.top = "${top}px";
  }

  void _onMenuFadeInStart() {
    // TODO(btmura): extract toggling of display style to utility class
    _continueButton.style.display = continueButtonVisible ? "block" : "none";

    // Add menu first to calculate it's height before centering it.
    document.body.children.add(_menu);

    _centerVertically();
  }

  void _onMenuFadeOutEnd() {
    _menu.remove();
  }
}