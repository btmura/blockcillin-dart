part of blockcillin;

/// The button bar above the game used to pause the game.
class ButtonBar {

  final DivElement _buttonBar;
  final ButtonElement _pauseButton;
  final Fader _fader;

  /// Creates the button bar with the production DOM tree and content.
  factory ButtonBar() {
    var pauseButton = new ButtonElement();
    pauseButton.text = "Pause";
    pauseButton.className = "game-menu-button";

    var buttonBar = new DivElement();
    buttonBar.className = "button-bar";
    buttonBar.append(pauseButton);

    var fader = new Fader(buttonBar);

    return new ButtonBar._(buttonBar, pauseButton, fader);
  }

  ButtonBar._(this._buttonBar, this._pauseButton, this._fader);

  /// DOM Element of the button bar. Add it to the DOM to show the bar.
  Element get element => _buttonBar;

  /// Height of the button bar. Use this when reacting to window sive changes.
  int get height => _buttonBar.clientHeight;

  /// Pause button click stream. Listen to this to pause the game.
  ElementStream<MouseEvent> get onPauseButtonClick => _pauseButton.onClick;

  /// Shows the menu gradually.
  void show() {
    _fader.fadeIn();
  }

  /// Hides the menu gradually.
  void hide() {
    _fader.fadeOut();
  }
}