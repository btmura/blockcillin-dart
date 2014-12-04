part of client;

class GameView {

  final ButtonBar buttonBar;
  final CanvasElement canvas;

  final webgl.RenderingContext _gl;
  final GLProgram _program;
  final BoardRenderer _boardRenderer;

  Float32List _projectionMatrix;

  GameView(this.buttonBar, this.canvas, this._gl, this._program, this._boardRenderer) {
    _gl.clearColor(0.0, 0.0, 0.0, 1.0);
    _projectionMatrix = _makeProjectionMatrix();
  }

  void draw(Game game) {
    _gl.clear(webgl.COLOR_BUFFER_BIT | webgl.DEPTH_BUFFER_BIT);
    _gl.viewport(0, 0, canvas.width, canvas.height);

    _gl.useProgram(_program.program);
    _gl.uniformMatrix4fv(_program.projectionMatrixLocation, false, _projectionMatrix);

    _boardRenderer.render(game.board);
  }

  Float32List _makeProjectionMatrix() {
    var aspect = canvas.width / canvas.height;
    var fovRadians = math.PI / 2;
    return _makePerspectiveMatrix(fovRadians, aspect, 1.0, 2000.0);
  }

  Float32List _makePerspectiveMatrix(double fovRadians, double aspect, double near, double far) {
    var f = math.tan(math.PI * 0.5 - 0.5 * fovRadians);
    var rangeInv = 1.0 / (near - far);
    return new Float32List.fromList([
        f / aspect, 0.0, 0.0, 0.0,
        0.0, f, 0.0, 0.0,
        0.0, 0.0, (near + far) * rangeInv, -1.0,
        0.0, 0.0, near * far * rangeInv * 2.0, 0.0
    ]);
  }

  bool resize() {
    if (_maximizeCanvas()) {
      _projectionMatrix = _makeProjectionMatrix();
      return true;
    }
    return false;
  }

  bool _maximizeCanvas() {
    var height = document.body.clientHeight - buttonBar.height;

    var changed = false;

    // Adjust the height of the canvas if it has changed.
    if (canvas.clientHeight != height) {
      canvas.style.height = "${height}px";
      changed = true;
    }

    // Adjust the canvas dimensions to match it's displayed size to avoid scaling.
    if (canvas.width != canvas.clientWidth || canvas.height != canvas.clientHeight) {
      canvas
          ..width = canvas.clientWidth
          ..height = canvas.clientHeight;
      changed = true;
    }

    return changed;
  }
}