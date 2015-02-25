part of blockcillin;

class GameView {

  final ButtonBar _buttonBar;
  final CanvasElement _canvas;
  final webgl.RenderingContext _gl;
  final ImageElement _textureImage;

  Matrix4 _viewMatrix;
  Matrix4 _projectionViewMatrix;
  Matrix4 _normalMatrix;

  BoardProgram _boardProgram;
  BoardRenderer _boardRenderer;

  GameView(this._buttonBar, this._canvas, this._gl, this._textureImage) {
    _viewMatrix = _makeViewMatrix();
    _projectionViewMatrix = _viewMatrix * _makeProjectionMatrix();
    _normalMatrix = _viewMatrix.inverse().transpose();

    _boardProgram = new BoardProgram(_gl);
    _boardRenderer = new BoardRenderer(_gl, _boardProgram);
  }

  void init() {
    _gl
        ..clearColor(0.0, 0.0, 0.0, 1.0)
        ..enable(webgl.DEPTH_TEST);

    _gl
        ..bindTexture(webgl.TEXTURE_2D, _gl.createTexture())
        ..texImage2D(webgl.TEXTURE_2D, 0, webgl.RGBA, webgl.RGBA, webgl.UNSIGNED_BYTE, _textureImage)
        ..texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MAG_FILTER, webgl.LINEAR)
        ..texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MIN_FILTER, webgl.LINEAR_MIPMAP_NEAREST)
        ..generateMipmap(webgl.TEXTURE_2D);
  }

  void setGame(Game newGame) {
    _boardRenderer.setBoard(newGame.board);
  }

  void draw() {
    _gl
      ..clear(webgl.COLOR_BUFFER_BIT | webgl.DEPTH_BUFFER_BIT)
      ..viewport(0, 0, _canvas.width, _canvas.height);

    _gl
      ..useProgram(_boardProgram.program)
      ..uniformMatrix4fv(_boardProgram.projectionViewMatrixUniform, false, _projectionViewMatrix.floatList)
      ..uniformMatrix4fv(_boardProgram.normalMatrixUniform, false, _normalMatrix.floatList);

    _boardRenderer.render();
  }

  Matrix4 _makeProjectionMatrix() {
    var aspect = _canvas.width / _canvas.height;
    var fovRadians = math.PI / 2;
    return new Matrix4.perspective(fovRadians, aspect, 1.0, 2000.0);
  }

  Matrix4 _makeViewMatrix() {
    var cameraPosition = new Vector3(0.0, 0.5, 3.0);
    var targetPosition = new Vector3(0.0, 0.0, 0.0);
    var up = new Vector3(0.0, 1.0, 0.0);
    return new Matrix4.view(cameraPosition, targetPosition, up);
  }

  bool resize() {
    if (_maximizeCanvas()) {
      _projectionViewMatrix = _viewMatrix * _makeProjectionMatrix();
      return true;
    }
    return false;
  }

  bool _maximizeCanvas() {
    var height = document.body.clientHeight - _buttonBar.height;

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