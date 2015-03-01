part of blockcillin;

/// Renderer of the selector.
class SelectorRenderer {

  final webgl.RenderingContext _gl;
  final SelectorProgram _program;
  webgl.Buffer _positionBuffer;
  webgl.Buffer _textureCoordBuffer;
  webgl.Buffer _indexBuffer;

  SelectorRenderer(this._gl, this._program);

  void init() {
    var positions = [
      new Vector3(1.0, 1.0, 0.0),
      new Vector3(-1.0, 1.0, 0.0),
      new Vector3(-1.0, -1.0, 0.0),
      new Vector3(1.0, -1.0, 0.0),
    ];

    var translation = new Vector3(0.0, 0.0, 1.0);
    positions = positions.map((v) => v + translation).toList();

    var textureCoords = [
      new Vector2(1.0, 0.0), // right top
      new Vector2(0.0, 0.0), // left top
      new Vector2(0.0, 1.0), // left bottom
      new Vector2(1.0, 1.0), // right bottom
    ];

    textureCoords = _toTextureTileCoords(textureCoords, 0, 4);

    var indices = [
      0, 1, 2,
      2, 3, 0,
    ];

    _positionBuffer = newArrayBuffer(_gl, Vector3.flatten(positions));
    _textureCoordBuffer = newArrayBuffer(_gl, Vector2.flatten(textureCoords));
    _indexBuffer = newElementArrayBuffer(_gl, indices);
  }

  void render() {
    _program.useProgram();
    if (_indexBuffer != null) {
      _program.enableArrays(_positionBuffer, _textureCoordBuffer);
      drawTriangles(_gl, _indexBuffer, 6);
      _program.disableArrays();
    }
  }
}
