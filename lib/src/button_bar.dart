library button_bar;

import 'dart:html';

class ButtonBar {

  final DivElement _buttonBar;
  final ButtonElement _pauseButton;

  ButtonBar(this._buttonBar, this._pauseButton);

  factory ButtonBar.attached() {
    ButtonElement pauseButton = new ButtonElement()
        ..text = "Pause";

    DivElement buttonBar = new DivElement()
        ..className = "button-bar"
        ..append(pauseButton);

    document.body.children.add(buttonBar);

    return new ButtonBar(buttonBar, pauseButton);
  }

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