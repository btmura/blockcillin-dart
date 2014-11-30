library button_bar;

import 'dart:html';

class ButtonBar {

  final DivElement _buttonBar;
  final ButtonElement _pauseButton;

  ButtonBar()
      : _buttonBar = new DivElement()
            ..className = "button-bar",
        _pauseButton = new ButtonElement()
            ..text = "Pause" {
    _buttonBar.append(_pauseButton);
  }

  void add() {
    document.body.children.add(_buttonBar);
  }

  void remove() {
    _buttonBar.remove();
  }

  int get height => _buttonBar.clientHeight;

  ElementStream<MouseEvent> get onPauseButtonClick => _pauseButton.onClick;

  bool get visible => _buttonBar.style.visibility != "hidden";

  void set visible(bool visible) {
    _buttonBar.style.visibility = visible ? "visible" : "hidden";
  }
}