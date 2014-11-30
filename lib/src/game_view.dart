library game_view;

import 'dart:html';

import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/board_renderer.dart';
import 'package:blockcillin/src/button_bar.dart';
import 'package:blockcillin/src/game.dart';
import 'package:blockcillin/src/gl.dart';

class GameView {

  final ButtonBar buttonBar;
  final CanvasElement _canvas;

  webgl.RenderingContext _gl;
  BoardRenderer _boardRenderer;

  GameView()
      : buttonBar = new ButtonBar(),
        _canvas = new CanvasElement()
            ..className = "canvas";

  bool init() {
    buttonBar.add();
    document.body.children.add(_canvas);

    resize();
    return _setupGL();
  }

  bool resize() {
    var changed = false;

    // Adjust the height of the canvas if it has changed.
    var wantedHeight = document.body.clientHeight - buttonBar.height;
    if (_canvas.clientHeight != wantedHeight) {
      _canvas.style.height = "${wantedHeight}px";
      changed = true;
    }

    // Adjust the canvas dimensions to match it's displayed size to avoid scaling.
    if (_canvas.width != _canvas.clientWidth || _canvas.height != _canvas.clientHeight) {
      _canvas
          ..width = _canvas.clientWidth
          ..height = _canvas.clientHeight;
      changed = true;
    }

    return changed;
  }

  bool _setupGL() {
    _gl = getWebGL(_canvas);
    if (_gl == null) {
      return false;
    }

    _boardRenderer = new BoardRenderer(_gl);
    if (!_boardRenderer.init()) {
      return false;
    }

    _gl.clearColor(0.0, 0.0, 0.0, 1.0);
    return true;
  }

  void draw(Game game) {
    _gl.clear(webgl.COLOR_BUFFER_BIT);
    _boardRenderer.render(game.board);
  }
}