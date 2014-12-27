part of client;

class MainMenu {

  final DivElement _mainMenu;
  final ButtonElement _continueGameButton;
  final ButtonElement _newGameButton;

  // TODO(btmura): extract fade-in and fade-out code to mixin or helper
  StreamSubscription<TransitionEvent> _fadeInSubscription;
  StreamSubscription<TransitionEvent> _fadeOutSubscription;

  bool _continueGameButtonVisible = false;

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
    _continueGameButtonVisible = visible;
  }

  void _show() {
    if (_fadeInSubscription == null) {
      // Add menu first to calculate it's height before centering it.
      _continueGameButton.style.display = _continueGameButtonVisible ? "block" : "none";
      document.body.children.add(_mainMenu);
      _centerVertically();

      _fadeInSubscription = _mainMenu.onTransitionEnd.listen((_) {});

      if (_fadeOutSubscription != null) {
        _fadeOutSubscription.cancel();
        _fadeOutSubscription = null;
      }

      _mainMenu.classes.add("fade-in");
      _mainMenu.classes.remove("fade-out");
    }
  }

  void _hide() {
    if (_fadeOutSubscription == null) {
      if (_fadeInSubscription != null) {
        _fadeInSubscription.cancel();
        _fadeInSubscription = null;
      }

      _fadeOutSubscription = _mainMenu.onTransitionEnd.listen((_) {
        _mainMenu.remove();
      });

      _mainMenu.classes.remove("fade-in");
      _mainMenu.classes.add("fade-out");
    }
  }

  void _centerVertically() {
    var top = math.max(document.body.clientHeight - _mainMenu.clientHeight, 0.0) / 2.0;
    _mainMenu.style.top = "${top}px";
  }
}