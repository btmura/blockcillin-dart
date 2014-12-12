part of client;

class GameView {

  final ButtonBar buttonBar;
  final CanvasElement canvas;

  final webgl.RenderingContext _gl;
  final GLProgram _program;
  final BoardRenderer _boardRenderer;

  Matrix4 _projectionMatrix;
  Matrix4 _viewMatrix;

  GameView(this.buttonBar, this.canvas, this._gl, this._program, this._boardRenderer) {
    _gl
      ..clearColor(0.0, 0.0, 0.0, 1.0)
      ..enable(webgl.DEPTH_TEST);

    _projectionMatrix = _makeProjectionMatrix();
    _viewMatrix = _makeViewMatrix();
  }

  void draw(Game game) {
    _gl.clear(webgl.COLOR_BUFFER_BIT | webgl.DEPTH_BUFFER_BIT);
    _gl.viewport(0, 0, canvas.width, canvas.height);

    _gl.useProgram(_program.program);
    _gl.uniformMatrix4fv(_program.projectionMatrixLocation, false, _projectionMatrix.floatList);
    _gl.uniformMatrix4fv(_program.viewMatrixLocation, false, _viewMatrix.floatList);

    _boardRenderer.render(game.board);
  }

  Matrix4 _makeProjectionMatrix() {
    var aspect = canvas.width / canvas.height;
    var fovRadians = math.PI / 2;
    return new Matrix4.perspective(fovRadians, aspect, 1.0, 2000.0);
  }

  Matrix4 _makeViewMatrix() {
    var cameraPosition = new Vector3(0.0, 0.1, 3.0);
    var targetPosition = new Vector3(0.0, 0.0, 0.0);
    var up = new Vector3(0.0, 1.0, 0.0);
    return new Matrix4.view(cameraPosition, targetPosition, up);
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