part of client;

class ButtonBar {

  // TODO(btmura): fix ButtonBar tests

  final DivElement _buttonBar;
  final ButtonElement _pauseButton;
  final Fader _fader;

  factory ButtonBar(DivElement buttonBar, ButtonElement pauseButton) {
    Fader fader = new Fader(buttonBar);
    return new ButtonBar._(buttonBar, pauseButton, fader);
  }

  ButtonBar._(this._buttonBar, this._pauseButton, this._fader);

  int get height => _buttonBar.clientHeight;

  ElementStream<MouseEvent> get onPauseButtonClick => _pauseButton.onClick;

  void set visible(bool visible) {
    if (visible) {
      _fader.fadeIn();
    } else {
      _fader.fadeOut();
    }
  }
}