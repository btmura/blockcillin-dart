part of blockcillin;

class GameView {

  final ButtonBar _buttonBar;
  final CanvasElement _canvas;
  final webgl.RenderingContext _gl;
  final ImageElement _textureImage;

  BoardProgram _boardProgram;
  BoardRenderer _boardRenderer;
  SelectorProgram _selectorProgram;
  SelectorRenderer _selectorRenderer;
  Matrix4 _viewMatrix;

  GameView(this._buttonBar, this._canvas, this._gl, this._textureImage) {
    _boardProgram = new BoardProgram(_gl);
    _boardRenderer = new BoardRenderer(_gl, _boardProgram);
    _selectorProgram = new SelectorProgram(_gl);
    _selectorRenderer = new SelectorRenderer(_gl, _selectorProgram);
    _viewMatrix = _makeViewMatrix();
  }

  void init() {
    _gl.clearColor(0.0, 0.0, 0.0, 1.0);
    _gl.enable(webgl.DEPTH_TEST);
    _gl.enable(webgl.BLEND);
    _gl.blendFunc(webgl.SRC_ALPHA, webgl.ONE_MINUS_SRC_ALPHA);

    _gl.bindTexture(webgl.TEXTURE_2D, _gl.createTexture());
    _gl.texImage2D(webgl.TEXTURE_2D, 0, webgl.RGBA, webgl.RGBA, webgl.UNSIGNED_BYTE, _textureImage);
    _gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MAG_FILTER, webgl.LINEAR);
    _gl.texParameteri(webgl.TEXTURE_2D, webgl.TEXTURE_MIN_FILTER, webgl.LINEAR_MIPMAP_NEAREST);
    _gl.generateMipmap(webgl.TEXTURE_2D);

    _updateProjectionMatrix();
    _updateNormalMatrix();

    _selectorRenderer.init();
  }

  void setGame(Game newGame) {
    _boardRenderer.setBoard(newGame.board);
  }

  void draw() {
    _gl.clear(webgl.COLOR_BUFFER_BIT | webgl.DEPTH_BUFFER_BIT);
    _boardRenderer.render();
    _selectorRenderer.render();
  }

  bool resize() {
    if (_maximizeCanvas()) {
      _updateProjectionMatrix();
      _gl.viewport(0, 0, _canvas.width, _canvas.height);
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
      _canvas.width = _canvas.clientWidth;
      _canvas.height = _canvas.clientHeight;
      changed = true;
    }

    return changed;
  }

  void _updateProjectionMatrix() {
    var projectionViewMatrix = _viewMatrix * _makeProjectionMatrix();
    _boardProgram
      ..useProgram()
      ..setProjectionViewMatrix(projectionViewMatrix);
    _selectorProgram
      ..useProgram()
      ..setProjectionViewMatrix(projectionViewMatrix);
  }

  void _updateNormalMatrix() {
    var normalMatrix = _viewMatrix.inverse().transpose();
    _boardProgram.useProgram();
    _boardProgram.setNormalMatrix(normalMatrix);
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
}