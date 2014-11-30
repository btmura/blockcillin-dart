library gl_canvas;

import 'dart:html';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/gl.dart';

class GLCanvas {

  final CanvasElement _canvas = new CanvasElement()
      ..className = "canvas";

  webgl.RenderingContext _gl;

  webgl.RenderingContext get gl => _gl;
  int get width => _canvas.width;
  int get height => _canvas.height;

  bool init() {
    _gl = getWebGL(_canvas);
    return _gl != null;
  }

  void add() {
    document.body.children.add(_canvas);
  }

  void remove() {
    _canvas.remove();
  }

  bool resize(int height) {
    var changed = false;

    // Adjust the height of the canvas if it has changed.
    if (_canvas.clientHeight != height) {
      _canvas.style.height = "${height}px";
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
}