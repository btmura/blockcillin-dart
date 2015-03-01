part of blockcillin;

/// Renderer of the selector.
class SelectorRenderer {

  final webgl.RenderingContext _gl;
  final SelectorProgram _program;
  webgl.Buffer _positionBuffer;
  webgl.Buffer _textureCoordBuffer;
  webgl.Buffer _indexBuffer;
  int _indexCount;

  SelectorRenderer(this._gl, this._program);

  void init() {
    var width = 1.0;

    var positions = [
      new Vector3(0.0, 1.0, 0.0),   // rt
      new Vector3(-1.0, 1.0, 0.0),  // lt
      new Vector3(-1.0, -1.0, 0.0), // lb
      new Vector3(0.0, -1.0, 0.0),  // rb

      new Vector3(1.0, 1.0, 0.0),   // rt
      new Vector3(0.0, 1.0, 0.0),   // lt
      new Vector3(0.0, -1.0, 0.0),  // lb
      new Vector3(1.0, -1.0, 0.0),  // rb
    ];

    var translation = new Vector3(0.0, 0.0, 1.0);
    positions = positions.map((v) => v + translation).toList();

    var textureCoords = [
      new Vector2(1.0, 0.0), // rt
      new Vector2(0.0, 0.0), // lt
      new Vector2(0.0, 1.0), // lb
      new Vector2(1.0, 1.0), // rb

      new Vector2(1.0, 0.0), // rt
      new Vector2(0.0, 0.0), // lt
      new Vector2(0.0, 1.0), // lb
      new Vector2(1.0, 1.0), // rb
    ];

    textureCoords = _toTextureTileCoords(textureCoords, 0, 4);

    var indices = [
      0, 1, 2,
      2, 3, 0,

      4, 5, 6,
      6, 7, 4,
    ];
    _indexCount = indices.length;

    _positionBuffer = newArrayBuffer(_gl, Vector3.flatten(positions));
    _textureCoordBuffer = newArrayBuffer(_gl, Vector2.flatten(textureCoords));
    _indexBuffer = newElementArrayBuffer(_gl, indices);
  }

  void render() {
    if (_indexBuffer != null) {
      _gl.enable(webgl.BLEND);

      _program.useProgram();
      _program.enableArrays(_positionBuffer, _textureCoordBuffer);
      drawTriangles(_gl, _indexBuffer, _indexCount);
      _program.disableArrays();

      _gl.disable(webgl.BLEND);
    }
  }
}
