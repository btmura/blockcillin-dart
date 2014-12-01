library gl_canvas;

import 'dart:html';
import 'dart:web_gl' as webgl;

import 'package:blockcillin/src/gl.dart';

class GLCanvas {

  final CanvasElement _canvas;
  final webgl.RenderingContext gl;

  GLCanvas(this._canvas, this.gl);

  factory GLCanvas.attached() {
    var canvas = new CanvasElement()
        ..className = "canvas";

    var gl = getWebGL(canvas);
    if (gl == null) {
      throw new StateError("couldn't get GL rendering context");
    }

    document.body.children.add(canvas);

    return new GLCanvas(canvas, gl);
  }

  int get width => _canvas.width;
  int get height => _canvas.height;

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

  void detach() {
    _canvas.remove();
  }
}