part of client;

class ButtonBar {

  final DivElement _buttonBar;
  final ButtonElement _pauseButton;

  ButtonBar(this._buttonBar, this._pauseButton);

  int get height => _buttonBar.clientHeight;

  ElementStream<MouseEvent> get onPauseButtonClick => _pauseButton.onClick;

  bool get visible => _buttonBar.style.visibility != "hidden";

  void set visible(bool visible) {
    _buttonBar.style.visibility = visible ? "visible" : "hidden";
  }

  void detach() {
    _buttonBar.remove();
  }
}